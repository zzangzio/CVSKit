//
//  FragileWindow.swift
//  LineUICore
//
//  Created by zzangzio on 2020. 02. 18..
//  Copyright © 2020년 zzangzio. All rights reserved.
//

import UIKit

public class FragileWindow: UIWindow {
    private weak var imageView: UIImageView?
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public init(frame: CGRect, maximumStress: Int, repeated: Bool) {
        self.maximumStress = maximumStress
        self.repeated = repeated
        super.init(frame: frame)
    }

    private var lastEndedPoint: CGPoint?
    private let repeated: Bool
    private let maximumStress: Int
    private var stress = 0
    public func pressure() -> Bool {
        guard let point = lastEndedPoint else { return false }
        return pressure(at: point)
    }

    public func pressure(at point: CGPoint) -> Bool {
        stress += 1
        guard maximumStress == stress else { return false }
        broken(at: point)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        if repeated {
            stress = 0
        }
        return true
    }

    private func broken(at point: CGPoint) {
        guard imageView == nil else { return }
        let imageView = UIImageView.autoLayoutView()
        imageView.isUserInteractionEnabled = true
        imageView.image = asImage.fragile(at: point)
        addSubview(imageView)
        imageView.allConstraints(equalTo: self).activate()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageView.addGestureRecognizer(tapGesture)
        self.imageView = imageView
    }

    @objc private func didTap() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            self.imageView?.alpha = 0
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.imageView?.removeFromSuperview()
            self.imageView = nil
        })
    }

    override public func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        lastEndedPoint = event.allTouches?.first?.location(in: self)
    }
}

extension UIImage {
    func fragile(at point: CGPoint) -> UIImage {
        _fragileImage(at: point)._fragileImage(at: point)
    }

    private func _fragileImage(at point: CGPoint) -> UIImage {
        UIImage.create(size: size, opaque: true, scale: scale.boundary(minimum: scale, maximum: 2)) { context in
            let length = sqrt(pow(size.width, 2) + pow(size.height, 2))
            var angle = CGFloat(0)
            let path = UIBezierPath()
            var point1 = CGPoint(x: point.x + length, y: point.y)
            UIColor.black.setFill()
            context.fill(size.rect)
            while angle < 360 {
                angle += CGFloat.random(in: 2 ... 15)
                angle = min(angle, 360)
                let cos = CoreGraphics.cos(CGFloat.pi * angle / 180.0)
                let sin = CoreGraphics.sin(CGFloat.pi * angle / 180.0)
                path.removeAllPoints()
                path.move(to: point1)
                let adjustPoint = CGPoint(
                    x: point.x + CGFloat.random(in: min(cos * 5, 0) ... max(cos * 5, 0)),
                    y: point.y + CGFloat.random(in: min(sin * 5, 0) ... max(sin * 5, 0))
                )
                path.addLine(to: adjustPoint)
                let point2 = CGPoint(
                    x: (cos * length) + adjustPoint.x,
                    y: (sin * length) + adjustPoint.y
                )
                path.addLine(to: point2)
                context.saveGState()
                path.addClip()
                let drawPoint = CGPoint(
                    x: CGFloat.random(in: min(cos * 15, 0) ... max(cos * 15, 0)),
                    y: CGFloat.random(in: min(sin * 15, 0) ... max(sin * 15, 0))
                )
                draw(at: drawPoint)
                context.restoreGState()
                point1 = point2
            }
        }
    }
}
