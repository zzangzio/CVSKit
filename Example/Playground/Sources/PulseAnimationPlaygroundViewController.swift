//
//  PulseAnimationPlaygroundViewController.swift
//  Playground
//
//  Created by simjs on 2018. 12. 10..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit
import CVSKit

class PulseAnimationPlaygroundViewController: PlaygroundViewController {
    override class var playgroundTitle: String {
        return "Pulse animation Playground"
    }

    private let playButton: UIButton = {
        let button = UIButton.autoLayoutView(type: .custom)
        button.title = "play".localized()
        button.setTitleColor(UIColor(rgb: 0x2323EE))

        return button
    }()

    private let stopButton: UIButton = {
        let button = UIButton.autoLayoutView(type: .custom)
        button.title = "stop".localized()
        button.setTitleColor(UIColor(rgb: 0xEE2323))

        return button
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView.autolayoutView(image: UIImage(named: "pulse")!)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(imageView)
        view.addSubview(playButton)
        view.addSubview(stopButton)

        let layoutGuide = view.backportSafeAreaLayoutGuide

        [imageView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
         imageView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
         stopButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor, constant: -50),
         stopButton.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -30),
         playButton.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor, constant: 50),
         playButton.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -30)].activate()

        stopButton.setAction { [weak self] _ in
            guard let self = self else { return }
            self.imageView.stopPulse()
        }

        playButton.setAction { [weak self] _ in
            guard let self = self else { return }
            self.imageView.startPulse()
        }
    }
}
