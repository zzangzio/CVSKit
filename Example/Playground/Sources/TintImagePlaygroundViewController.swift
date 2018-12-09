//
//  TintImagePlaygroundViewController.swift
//  Playground
//
//  Created by simjs on 2018. 12. 9..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit
import CVSKit

class TintImagePlaygroundViewController: PlaygroundViewController {
    override class var playgroundTitle: String {
        return "Tint image Playground"
    }

    private let originImageView: UIImageView = {
        let imageView = UIImageView.autolayoutView(image: UIImage(named: "tint_color")!)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let tintImageView: UIImageView = {
        let imageView = UIImageView.autolayoutView(image: UIImage(named: "tint_color")!)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let tintColorButtons = TintColorButtons.autoLayoutView()

    private lazy var defaultConstraints: [NSLayoutConstraint] = {
        let layoutGuide = view.backportSafeAreaLayoutGuide
        
        return [tintColorButtons.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
                tintColorButtons.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 20),
                originImageView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
                originImageView.topAnchor.constraint(equalTo: tintColorButtons.bottomAnchor),
                tintImageView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
                tintImageView.topAnchor.constraint(equalTo: originImageView.bottomAnchor)]
    }()

    private lazy var compactConstraints: [NSLayoutConstraint] = {
        let layoutGuide = view.backportSafeAreaLayoutGuide

        return [tintColorButtons.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
                tintColorButtons.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 20),
                originImageView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
                originImageView.leadingAnchor.constraint(equalTo: tintColorButtons.trailingAnchor),
                tintImageView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
                tintImageView.leadingAnchor.constraint(equalTo: originImageView.trailingAnchor)]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        tintColorButtons.delegate = self

        view.addSubview(tintColorButtons)
        view.addSubview(originImageView)
        view.addSubview(tintImageView)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard previousTraitCollection != traitCollection else { return }
        if traitCollection.verticalSizeClass == .compact {
            defaultConstraints.deactivate()
            compactConstraints.activate()
        }
        else {
            compactConstraints.deactivate()
            defaultConstraints.activate()
        }
    }
}

extension TintImagePlaygroundViewController: TintColorButtonsDelegate {
    fileprivate func tintColorButtons(_ buttons: TintColorButtons, didTapButtonWith color: UIColor) {
        tintImageView.fadeTransition()
        tintImageView.image = originImageView.image?.with(tintColor: color)
    }
}

fileprivate protocol TintColorButtonsDelegate: NSObjectProtocol {
    func tintColorButtons(_ buttons: TintColorButtons, didTapButtonWith color: UIColor)
}

fileprivate class TintColorButtons: UIView {
    private enum Design {
        static let buttonSize = CGSize(width: 50, height: 50)
    }

    private lazy var tintColorButtons: [UIButton] = {
        return [self.createButton(with: 0xFF0000),
                self.createButton(with: 0x00FF00),
                self.createButton(with: 0x0000FF),
                self.createButton(with: 0xFF00FF),
                self.createButton(with: 0xFFFF00),
                self.createButton(with: 0x00FFFF)]
    }()

    private func createButton(with rgb: Int) -> UIButton {
        let button = UIButton(type: .custom)
        let color = UIColor(rgb: rgb)
        button.size = Design.buttonSize

        button.setBackgroundImage(UIImage.init(color: color))
        button.tag = rgb
        button.addTarget(self, action: #selector(didTapTintColorButton(_:)))

        return button
    }

    @objc private func didTapTintColorButton(_ button: UIButton) {
        delegate?.tintColorButtons(self, didTapButtonWith: UIColor(rgb: button.tag))
    }

    weak var delegate: TintColorButtonsDelegate?

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
    }

    private func configureContentView() {
        tintColorButtons.forEach { addSubview($0) }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard previousTraitCollection != traitCollection else { return }
        invalidateIntrinsicContentSize()
    }

    public override var intrinsicContentSize: CGSize {
        let buttonCount = CGFloat(tintColorButtons.count)
        let buttonSize = Design.buttonSize
        if traitCollection.verticalSizeClass == .compact {
            return CGSize(width: buttonSize.width, height: buttonSize.height * buttonCount)
        }
        else {
            return CGSize(width: buttonSize.width * buttonCount, height: buttonSize.height)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if traitCollection.verticalSizeClass == .compact {
            var originY: CGFloat = 0
            tintColorButtons.forEach { $0.origin = CGPoint(x: 0, y: originY)
                originY += $0.height
            }
        }
        else {
            var originX: CGFloat = 0
            tintColorButtons.forEach { $0.origin = CGPoint(x: originX, y: 0)
                originX += $0.height
            }
        }
    }
}
