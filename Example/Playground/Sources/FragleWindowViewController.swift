//
//  FragleWindowViewController.swift
//  Playground
//
//  Created by zzangzio on 2020. 02. 18..
//  Copyright © 2020년 zzangzio. All rights reserved.
//

import CVSKit
import UIKit

class FragleWindowViewController: PlaygroundViewController {
    override class var playgroundTitle: String {
        return "Fragile Window"
    }

    private let label = UILabel.autoLayoutView(font: .systemFont(ofSize: 15), color: .black)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        label.text = "Touch the screen carefully"

        view.addSubview(label)
        [
            label.centerXAnchor |= view.centerXAnchor,
            label.centerYAnchor |= view.centerYAnchor,
        ].activate()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    @objc private func didTap() {
        guard let window = view.window as? FragileWindow else { return }
        _ = window.pressure()
    }
}
