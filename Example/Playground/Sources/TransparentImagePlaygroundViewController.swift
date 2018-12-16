//
//  TransparentImagePlaygroundViewController.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 13..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit
import CVSKit

class TransparentImagePlaygroundViewController: PlaygroundViewController {

    override class var playgroundTitle: String {
        return "Transparent image"
    }

    private let originImageView: UIImageView = {
        let imageView = UIImageView.autolayoutView(image: UIImage(named: "sample")!)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let transparentImageView: UIImageView = {
        let imageView = UIImageView.autolayoutView(image: UIImage(named: "sample")!)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let transparentSlider: UISlider = {
        let slider = UISlider.autoLayoutView()
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.value = 1
        return slider
    }()

    private let transparentLabel: UILabel = {
        let label = UILabel.autoLayoutView()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textColor = UIColor(hex: "#232323")
        return label
    }()

    private lazy var defaultConstraints: [NSLayoutConstraint] = {
        let layoutGuide = view.backportSafeAreaLayoutGuide

        return [ transparentLabel.leadingAnchor |= (layoutGuide.leadingAnchor, 30),
                 transparentLabel.widthAnchor |= (40),
                 transparentLabel.centerYAnchor |= (layoutGuide.centerYAnchor),
                 transparentSlider.leadingAnchor |= (transparentLabel.trailingAnchor, 10),
                 transparentSlider.trailingAnchor |= (layoutGuide.trailingAnchor, -30),
                 transparentSlider.centerYAnchor |= (layoutGuide.centerYAnchor),
                 originImageView.centerXAnchor |= (layoutGuide.centerXAnchor),
                 originImageView.bottomAnchor |= (transparentSlider.topAnchor),
                 transparentImageView.centerXAnchor |= (layoutGuide.centerXAnchor),
                 transparentImageView.topAnchor |= (transparentSlider.bottomAnchor)]

    }()

    private lazy var compactConstraints: [NSLayoutConstraint] = {
        let layoutGuide = view.backportSafeAreaLayoutGuide

        return [ transparentLabel.widthAnchor |= (40),
                 transparentLabel.topAnchor |= (layoutGuide.topAnchor, 10),
                 transparentLabel.centerXAnchor |= layoutGuide.centerXAnchor,
                 transparentSlider.widthAnchor |= (layoutGuide.heightAnchor, -70),
                 transparentSlider.centerXAnchor |= layoutGuide.centerXAnchor,
                 transparentSlider.centerYAnchor |= (layoutGuide.centerYAnchor, 20),
                 originImageView.centerYAnchor |= (layoutGuide.centerYAnchor),
                 originImageView.trailingAnchor |= (transparentSlider.centerXAnchor, -10),
                 transparentImageView.centerYAnchor |= (layoutGuide.centerYAnchor),
                 transparentImageView.leadingAnchor |= (transparentSlider.centerXAnchor, 10)]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(transparentSlider)
        view.addSubview(transparentLabel)
        view.addSubview(originImageView)
        view.addSubview(transparentImageView)

        transparentLabel.text = String(format: "%.2f", transparentSlider.value)
        transparentSlider.addTarget(self, action: #selector(didChangeSliderValue(_:)), for: .touchUpInside)
        transparentSlider.addTarget(self, action: #selector(didChangeSliderValue(_:)), for: .touchUpOutside)
    }

    @objc private func didChangeSliderValue(_ slider: UISlider) {
        transparentImageView.fadeTransition()
        transparentImageView.image = originImageView.image?.with(alpha: CGFloat(slider.value))
        transparentLabel.text = String(format: "%.2f", transparentSlider.value)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard previousTraitCollection != traitCollection else { return }
        if traitCollection.verticalSizeClass == .compact {
            defaultConstraints.deactivate()
            compactConstraints.activate()
            transparentSlider.transform = CGAffineTransform(rotationAngle: -0.5 * .pi)
        }
        else {
            compactConstraints.deactivate()
            defaultConstraints.activate()
            transparentSlider.transform = .identity
        }
    }
}
