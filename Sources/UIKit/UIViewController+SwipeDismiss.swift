//
//  UIViewController+SwipeDismiss.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 22..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

private var swipeDismissTransitioningDelegateKey: UInt8 = 0
extension UIViewController {

    // Call this method after viewController has focus. e.g. in 'viewDidAppear:'
    public func configureInterctiveDismiss(enabled: Bool) {
        guard let presentedViewController = presentingViewController?.presentedViewController else { return }
        let transitioningDelegate = SwipeDismissTransitioningDelegate(self)
        presentedViewController.swipeDismissTransitioningDelegate = enabled ? transitioningDelegate : nil
    }

    private var swipeDismissTransitioningDelegate: SwipeDismissTransitioningDelegate? {
        get {
            return objc_getAssociatedObject(
                self,
                &swipeDismissTransitioningDelegateKey) as? SwipeDismissTransitioningDelegate
        }
        set {
            transitioningDelegate = newValue
            objc_setAssociatedObject(
                self,
                &swipeDismissTransitioningDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

@objc public protocol SwipeDismissViewControllerProtocol: NSObjectProtocol {
    @objc optional var shouldBeginSwipeDismiss: Bool { get }
    @objc optional var scrollViewForSwipeDismiss: UIScrollView { get }
    @objc optional var dimmingBackgroundViewForSwipeDismiss: UIView { get }

    @objc optional func willFinishSwipeDismiss()
    @objc optional func didFinishSwipeDismiss()
    @objc optional func didCancelSwipeDismiss()
}
