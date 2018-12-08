//
//  ViewController.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit
import CVSKit

class ViewController: UIViewController {

    let label: UILabel = UILabel.autoLayoutView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)

        label.text = "Hello CVSKit"
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        NSLayoutConstraint.activate(label.allConstraints(equalTo: view.backportSafeAreaLayoutGuide))

        let gr = UITapGestureRecognizer()
        gr.setAction { (_) in
            self.label.startPulse()
        }
        label.addGestureRecognizer(gr)
    }
}

