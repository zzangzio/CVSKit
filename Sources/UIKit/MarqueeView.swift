//
//  MarqueeView.swift
//  CVSKit
//
//  Created by zzangzio on 2020. 02. 18..
//  Copyright © 2020년 zzangzio. All rights reserved.
//

import UIKit

public class MarqueeView: UIView {
    public enum Fade {
        case none, leading, trailing, both
    }

    public enum HorizontalAlign {
        case center, leading, trailing
    }

    public var animationSpeed: CGFloat = 1
    public var fadeMode: MarqueeView.Fade = .none {
        didSet {
            applyFade()
        }
    }

    public var fadeRate: CGFloat = 0.1 {
        didSet {
            applyFade()
        }
    }

    public var horizontalAlign: MarqueeView.HorizontalAlign = .leading {
        didSet {
            layoutContentViews()
        }
    }

    public var spaceOfContents: CGFloat = 20

    private var contentView0 = UIImageView()
    private var contentView1 = UIImageView()
    private var displayLink: CADisplayLink?
    private var currentPanningX: CGFloat = 0
    private var panningStartX: CGFloat = 0
    private var userPanning = false
    private let isRightToLeft = UIView.isRightToLeft

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override public init(frame: CGRect) {
        super.init(frame: frame)

        configureContentView()
    }

    private func configureContentView() {
        clipsToBounds = true

        addSubview(contentView0)
        addSubview(contentView1)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanning(_:)))
        addGestureRecognizer(panGesture)
    }

    public func setContentView(_ contentView: UIView?) {
        guard let contentView = contentView else {
            contentView0.image = nil
            contentView1.image = nil
            setNeedsLayout()
            return
        }

        contentView.sizeToFit()
        contentView.layoutIfNeeded()
        let contentSize = contentView.size
        let contentImage = contentView.asImage
        contentView0.image = contentImage
        contentView1.image = contentImage
        contentView0.size = contentSize
        contentView1.size = contentSize

        currentPanningX = 0
        setNeedsLayout()
    }

    @objc private func didPanning(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            userPanning = true
            panningStartX = currentPanningX + gesture.translation(in: gesture.view).x
        case .changed:
            let currentTranslationX = gesture.translation(in: gesture.view).x
            if isRightToLeft {
                paning(toX: panningStartX + currentTranslationX)
            } else {
                paning(toX: panningStartX - currentTranslationX)
            }
        default:
            userPanning = false
        }
    }

    private func paning(toX x: CGFloat) {
        currentPanningX = x
        layoutContentViews()
    }

    private func pannig(byX x: CGFloat) {
        currentPanningX += x
        layoutContentViews()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutContentViews()
        applyFade()
    }

    override public var intrinsicContentSize: CGSize {
        contentView0.image?.size ?? .zero
    }

    private func layoutContentViews() {
        guard contentView0.image != nil else { return }

        let contentSize = contentView0.size
        let minimumOffset: CGFloat = 0.001
        if width >= contentSize.width || abs(contentSize.width - width) < minimumOffset {
            contentView1.isHidden = true

            let originX: CGFloat = {
                switch (horizontalAlign, isRightToLeft) {
                case (.leading, false), (.trailing, true):
                    return 0
                case (.trailing, false), (.leading, true):
                    return width - contentSize.width
                case (.center, _):
                    return width |- contentSize.width
                }
            }()

            contentView0.frame = CGRect(
                origin: CGPoint(x: originX, y: height |- contentSize.height),
                size: contentSize
            )
        } else {
            contentView1.isHidden = false
            currentPanningX = currentPanningX.truncatingRemainder(dividingBy: contentSize.width + spaceOfContents)
            if isRightToLeft {
                contentView0.origin = CGPoint(
                    x: width - contentSize.width + currentPanningX,
                    y: height |- contentSize.height
                )
                if currentPanningX > 0 {
                    contentView1.origin = CGPoint(
                        x: contentView0.frame.minX - spaceOfContents - contentSize.width,
                        y: height |- contentSize.height
                    )
                } else {
                    contentView1.origin = CGPoint(
                        x: contentView0.frame.maxX + spaceOfContents,
                        y: height |- contentSize.height
                    )
                }
            } else {
                contentView0.origin = CGPoint(x: -currentPanningX, y: height |- contentSize.height)
                if currentPanningX > 0 {
                    contentView1.origin = CGPoint(
                        x: contentView0.frame.maxX + spaceOfContents,
                        y: height |- contentSize.height
                    )
                } else {
                    contentView1.origin = CGPoint(
                        x: contentView0.frame.minX - spaceOfContents - contentSize.width,
                        y: height |- contentSize.height
                    )
                }
            }
        }
    }

    private func applyFade() {
        guard fadeMode != .none, width > 0, width < (contentView0.image?.size.width ?? 0) else {
            mask = nil
            return
        }

        let maskImage = UIImage.create(size: size) { context in
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors: [CGFloat] = {
                switch (fadeMode, isRightToLeft) {
                case (.leading, false), (.trailing, true):
                    return [
                        0, 0, 0, 0,
                        0, 0, 0, 1,
                        0, 0, 0, 1,
                        0, 0, 0, 1,
                    ]
                case (.trailing, false), (.leading, true):
                    return [
                        0, 0, 0, 1,
                        0, 0, 0, 1,
                        0, 0, 0, 1,
                        0, 0, 0, 0,
                    ]
                default:
                    return [
                        0, 0, 0, 0,
                        0, 0, 0, 1,
                        0, 0, 0, 1,
                        0, 0, 0, 0,
                    ]
                }
            }()

            let locations: [CGFloat] = [0, fadeRate / 2, 1 - (fadeRate / 2), 1]

            guard let gradient = CGGradient(
                colorSpace: colorSpace,
                colorComponents: colors,
                locations: locations,
                count: 4
            ) else { return }

            context.drawLinearGradient(
                gradient,
                start: .zero,
                end: CGPoint(x: self.width, y: 0),
                options: .drawsBeforeStartLocation
            )
        }
        mask = UIImageView(image: maskImage)
    }

    public var isAnimating: Bool {
        displayLink != nil
    }

    public func startAnimation() {
        guard displayLink == nil else { return }

        let displayLink = CADisplayLink(target: self, selector: #selector(updatePanningX))
        displayLink.add(to: RunLoop.main, forMode: .common)
        displayLink.preferredFramesPerSecond = 60

        self.displayLink = displayLink
    }

    public func stopAnimation() {
        displayLink?.remove(from: RunLoop.main, forMode: .common)
        displayLink = nil
    }

    @objc private func updatePanningX() {
        guard userPanning == false else { return }
        pannig(byX: animationSpeed)
    }
}
