//
//  UIGestureRecognizer+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

public extension UIGestureRecognizer {
    typealias GestureAction = ((UIGestureRecognizer) -> Void)

    func setAction(_ action: GestureAction?) {
        removeTarget(self, action: #selector(fireAction))

        if let action = action {
            actionWrapper = ActionWrapper(action: action)
            addTarget(self, action: #selector(fireAction))
        } else {
            actionWrapper = nil
        }
    }

    @objc private func fireAction() {
        actionWrapper?.action(self)
    }
}

private var ActionWrapperKey: UInt8 = 0
private extension UIGestureRecognizer {
    private struct ActionWrapper {
        let action: GestureAction
    }

    private var actionWrapper: ActionWrapper? {
        get {
            return objc_getAssociatedObject(self, &ActionWrapperKey) as? ActionWrapper
        }

        set {
            objc_setAssociatedObject(
                self,
                &ActionWrapperKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
