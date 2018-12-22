//
//  SwipeDismissPlaygroundViewController.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 22..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit
import CVSKit

class SwipeDismissPlaygroundViewController: PlaygroundViewController {
    override class var playgroundTitle: String {
        return "Interactive Swipe Dismiss"
    }

    private static var index: Int = 0

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView.autoLayoutView()
        return scrollView
    }()

    private let indexLabel: UILabel = {
        let label = UILabel.autoLayoutView(font: UIFont.boldSystemFont(ofSize: 50), color: .black)
        label.backgroundColor = .white
        return label
    }()

    private let modalButton: UIButton = {
        let button = UIButton.autoLayoutView(type: .system)
        button.backgroundColor = .white
        button.title = "Present modal"
        return button
    }()

    private let modalWithNavigationButton: UIButton = {
        let button = UIButton.autoLayoutView(type: .system)
        button.backgroundColor = .white
        button.title = "Present modal with navigation"
        return button
    }()

    private let pushButton: UIButton = {
        let button = UIButton.autoLayoutView(type: .system)
        button.backgroundColor = .white
        button.title = "Push"
        return button
    }()

    deinit { SwipeDismissPlaygroundViewController.index -= 1 }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb: Int.random(in: 0...Int.max))

        view.addSubview(scrollView)
        NSLayoutConstraint.activate(
            [ scrollView.leadingAnchor |= (view.leadingAnchor),
              scrollView.trailingAnchor |= (view.trailingAnchor),
              scrollView.topAnchor |= (view.topAnchor),
              scrollView.bottomAnchor |= (view.bottomAnchor)])

        SwipeDismissPlaygroundViewController.index += 1

        scrollView.addSubview(indexLabel)
        scrollView.addSubview(modalButton)
        scrollView.addSubview(modalWithNavigationButton)
        scrollView.addSubview(pushButton)

        NSLayoutConstraint.activate(
            [ indexLabel.centerXAnchor |= (scrollView.centerXAnchor),
              modalButton.centerXAnchor |= (scrollView.centerXAnchor),
              modalButton.widthAnchor |= (250),
              modalWithNavigationButton.centerXAnchor |= (scrollView.centerXAnchor),
              modalWithNavigationButton.widthAnchor |= (250),
              pushButton.centerXAnchor |= (scrollView.centerXAnchor),
              pushButton.widthAnchor |= (250),

              indexLabel.bottomAnchor |= (modalButton.topAnchor, -30),
              modalButton.bottomAnchor |= (modalWithNavigationButton.topAnchor, -20),
              modalWithNavigationButton.centerYAnchor |= (scrollView.centerYAnchor),
              pushButton.topAnchor |= (modalWithNavigationButton.bottomAnchor, 20)])

        indexLabel.text = "\(SwipeDismissPlaygroundViewController.index)"

        modalButton.setAction { [weak self] _ in
            guard let self = self else { return }
            self.present(SwipeDismissPlaygroundViewController(), animated: true, completion: nil)
        }

        modalWithNavigationButton.setAction { [weak self] _ in
            guard let self = self else { return }
            let navigationController = UINavigationController(rootViewController: SwipeDismissPlaygroundViewController())
            self.present(navigationController, animated: true, completion: nil)
        }

        pushButton.setAction { [weak self] _ in
            guard let self = self else { return }
            guard let navigationController = self.navigationController else {
                return
            }
            navigationController.pushViewController(SwipeDismissPlaygroundViewController(), animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureInterctiveDismiss(enabled: true)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.width, height: view.height * 2)
    }
}
