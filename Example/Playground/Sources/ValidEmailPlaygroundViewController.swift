//
//  ValidEmailPlaygroundViewController.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 9..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit
import CVSKit

class ValidEmailPlaygroundViewController: UIViewController {
    private let textField: UITextField = {
        let textField = UITextField.autoLayoutView()
        textField.keyboardType = .emailAddress
        textField.layer.borderColor = UIColor(hex: "0x323232")?.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        return textField
    }()

    private let checkButton: UIButton = {
        let button = UIButton.autoLayoutView(type: .custom)
        button.setTitleColor(UIColor(hex: "#323232"))
        button.title = "Check"
        return button
    }()

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(textField)
        view.addSubview(checkButton)

        let layoutGuide = view.backportSafeAreaLayoutGuide

        [textField.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 1, constant: -100),
         textField.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
         textField.heightAnchor.constraint(equalToConstant: 50),
         textField.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 50)].activate()

        [checkButton.widthAnchor.constraint(equalTo: textField.widthAnchor),
         checkButton.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
         checkButton.heightAnchor.constraint(equalToConstant: 50),
         checkButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30)].activate()

        checkButton.setAction { [weak self] _ in
            guard let self = self else { return }
            guard let email = self.textField.text?.trimming else { return }

            let title = email.isValidEmail ? "Valid :)" : "Invalid :("

            UIAlertController.alert(withtitle: title, message: nil)
            .addDefaultAction(title: "ok".localized())
            .presented(on: self)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkButton.becomeFirstResponder()
    }
}
