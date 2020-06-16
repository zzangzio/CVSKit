//
//  CircularProgressPlaygroundViewController.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 15..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import CVSKit
import UIKit

class CircularProgressPlaygroundViewController: PlaygroundViewController {
    override class var playgroundTitle: String {
        return "Circular progress"
    }

    private let circlarProgress: CircularProgressView = {
        let circlarProgress = CircularProgressView.autoLayoutView()
        circlarProgress.progressColor = .red
        circlarProgress.progressWidth = 8
        circlarProgress.trackWidth = 8
        return circlarProgress
    }()

    private let progressLabel: UILabel = {
        let label = UILabel.autoLayoutView(font: .systemFont(ofSize: 13), color: .black)
        label.text = "0%"
        return label
    }()

    private let startButton: UIButton = {
        let button = UIButton.autoLayoutView(type: .custom)
        button.title = "Start"
        button.setTitleColor(UIColor.blue)

        return button
    }()

    private let startWithRotateButton: UIButton = {
        let button = UIButton.autoLayoutView(type: .custom)
        button.title = "Start with rotate"
        button.setTitleColor(UIColor.red)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(circlarProgress)
        view.addSubview(startButton)
        view.addSubview(startWithRotateButton)
        view.addSubview(progressLabel)

        [
            circlarProgress.centerXAnchor |= view.centerXAnchor,
            circlarProgress.centerYAnchor |= (view.centerYAnchor, -50),
            circlarProgress.widthAnchor |= 80,
            circlarProgress.heightAnchor |= 80,
            startButton.centerXAnchor |= view.centerXAnchor,
            startButton.topAnchor |= (circlarProgress.bottomAnchor, 30),
            startWithRotateButton.centerXAnchor |= view.centerXAnchor,
            startWithRotateButton.topAnchor |= (startButton.bottomAnchor, 20),
            progressLabel.centerXAnchor |= circlarProgress.centerXAnchor,
            progressLabel.centerYAnchor |= circlarProgress.centerYAnchor,
        ].activate()

        let progressAction: ((CGFloat, CGFloat) -> Void) = { [weak self] total, progress in
            guard let self = self else { return }
            self.progressLabel.text = String(format: "%d%%", Int(progress * 100 / total))
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self = self else { return }
                self.circlarProgress.progress = progress
            })
        }

        let completeAction: (() -> Void) = { [weak self] in
            guard let self = self else { return }
            self.startButton.isUserInteractionEnabled = true
            self.startWithRotateButton.isUserInteractionEnabled = true

            UIAlertController.alert(withTitle: "complete".localized(), message: nil)
                .addDefaultAction(title: "ok".localized(), handler: { [weak self] _ in
                    guard let self = self else { return }
                    self.progressLabel.text = "0%"
                    self.circlarProgress.progress = 0
                }).presented(on: self)
        }

        startButton.setAction { [weak self] _ in
            guard let self = self else { return }

            self.startButton.isUserInteractionEnabled = false
            self.startWithRotateButton.isUserInteractionEnabled = false

            self.startWorking(withProgress: progressAction, completion: completeAction)
        }

        startWithRotateButton.setAction { [weak self] _ in
            guard let self = self else { return }

            self.startButton.isUserInteractionEnabled = false
            self.startWithRotateButton.isUserInteractionEnabled = false
            self.circlarProgress.startRotating()

            self.startWorking(withProgress: progressAction, completion: { [weak self] in
                guard let self = self else { return }
                self.circlarProgress.stopRotating()
                completeAction()
            })
        }
    }

    private func startWorking(
        withProgress progress: @escaping (CGFloat, CGFloat) -> Void,
        completion: @escaping () -> Void
    ) {
        let total = CGFloat(5)
        let progresses: [CGFloat] = [0.8, 1.0, 2.2, 2.5, 3.0, 3.2, 3.4, 3.6, 4.0, 4.5, 4.6, 5.0]
        circlarProgress.maxProgress = total

        progresses.forEach { each in
            DispatchQueue.main.after(TimeInterval(each)) {
                progress(total, each)
            }
        }

        DispatchQueue.main.after(TimeInterval(total + 0.1)) {
            completion()
        }
    }
}
