//
//  UIAlertController+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 9..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

public extension UIAlertController {
    static func alert(withTitle title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }

    static func actionSheet(withTitle title: String?, message: String?) -> UIAlertController {
        if UIDevice.isPad == false {
            return UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        } else {
            return UIAlertController(title: title, message: message, preferredStyle: .alert)
        }
    }

    static func actionSheet(
        withTitle title: String?,
        message: String?,
        sourceView: UIView,
        sourceRect: CGRect
    ) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = sourceView
        alertController.popoverPresentationController?.sourceRect = sourceRect

        return alertController
    }

    // Action
    @discardableResult
    func addDefaultAction(
        title: String,
        handler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertController {
        let action = UIAlertAction(title: title, style: .default, handler: handler)
        addAction(action)
        return self
    }

    @discardableResult
    func addCancelAction(
        title: String,
        handler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertController {
        let action = UIAlertAction(title: title, style: .cancel, handler: handler)
        addAction(action)
        return self
    }

    @discardableResult
    func addDestructiveAction(
        title: String,
        handler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertController {
        let action = UIAlertAction(title: title, style: .destructive, handler: handler)
        addAction(action)
        return self
    }

    func presented(on viewController: UIViewController) {
        viewController.present(self, animated: true, completion: nil)
    }
}
