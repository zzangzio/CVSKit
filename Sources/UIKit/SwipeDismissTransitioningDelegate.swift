//
//  SwipeDismissTransitioningDelegate.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 22..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit
import WebKit

class SwipeDismissTransitioningDelegate: NSObject {
    private weak var viewController: UIViewController?
    private var viewControllerProtocol: SwipeDismissViewControllerProtocol? {
        return viewController as? SwipeDismissViewControllerProtocol
    }

    private var panningView: UIView!
    private var isBegan: Bool = false
    private var beginTranslationY: CGFloat = 0
    private var progress: CGFloat = 0
    private var transitionContext: UIViewControllerContextTransitioning?
    private var dimmingBackgroundView: UIView?

    let progressThreshold: CGFloat = 0.3
    let animationDuration: TimeInterval = 0.35

    init(_ viewController: UIViewController) {
        super.init()

        self.viewController = viewController
        if let viewControllerProtocol = self.viewControllerProtocol,
            let scrollView = viewControllerProtocol.scrollViewForSwipeDismiss {
            panningView = scrollView
        }
        else {
            let contentView: UIView = {
                if let navigationController = viewController as? UINavigationController,
                    let topViewController = navigationController.topViewController {
                    return topViewController.view
                }
                return viewController.view
            }()

            panningView = searchScrollView(in: contentView) ?? contentView
        }
        self.configurePanGesture()
    }

    private func configurePanGesture() {
        let panGesture: UIPanGestureRecognizer = {
            if let scrollView = panningView as? UIScrollView {
                return scrollView.panGestureRecognizer
            }

            let panGesture = UIPanGestureRecognizer()
            panGesture.delegate = self
            panningView.addGestureRecognizer(panGesture)

            return panGesture
        }()

        let action = #selector(handlePanGesture(_:))
        panGesture.addTarget(self, action: action)
    }

    private func searchScrollView(in view: UIView) -> UIScrollView? {
        switch view {
        case let view as UIScrollView:
            return view
        case let view as UIWebView:
            return view.scrollView
        case let view as WKWebView:
            return view.scrollView
        default:
            return view.subviews.first { searchScrollView(in: $0) != nil } as? UIScrollView
        }
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if isBegan == false, canBeginSwipeDismiss(gesture) {
            beginSwipeDismiss(gesture)
            return
        }

        guard isBegan else { return }

        switch gesture.state {
        case .changed:
            let translationY = gesture.translation(in: panningView).y - beginTranslationY
            if translationY < 0 {
                cancelSwipeDismiss(animated: false)
            }
            else {
                updateSwipeDismiss(translationY)
            }
        case .cancelled, .ended, .failed:
            if progress > progressThreshold {
                finishSwipeDismiss()
            }
            else {
                cancelSwipeDismiss(animated: true)
            }
        default: ()
        }
    }

    private func canBeginSwipeDismiss(_ gesture: UIPanGestureRecognizer) -> Bool {
        let downDirection = gesture.translation(in: panningView).y > 0
        guard downDirection else { return false }
        guard viewControllerProtocol?.shouldBeginSwipeDismiss ?? true else { return false }

        guard let scrollView = panningView as? UIScrollView else { return true }

        let inset: UIEdgeInsets = scrollView.backportContentInset
        guard (scrollView.contentSize.width + inset.horizontal) <= scrollView.width else { return false }

        let minContentOffsetY = -inset.top
        return scrollView.contentOffset.y <= minContentOffsetY
    }

    private func beginSwipeDismiss(_ gesture: UIPanGestureRecognizer) {
        isBegan = true
        beginTranslationY = gesture.translation(in: panningView).y

        viewController?.dismiss(animated: true, completion: nil)
    }

    private func finishSwipeDismiss() {
        guard let context = transitionContext,
            let fromViewController = context.viewController(forKey: .from) else { return }

        viewControllerProtocol?.willFinishSwipeDismiss?()

        context.finishInteractiveTransition()
        fromViewController.view.isUserInteractionEnabled = false

        let duration = transitionDuration(using: transitionContext)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.3,
            options: [.beginFromCurrentState],
            animations: { [weak self] in
                guard let self = self else { return }
                self.dimmingBackgroundView?.alpha = 0
                fromViewController.view.transform = .init(translationX: 0,
                                                          y: fromViewController.view.height)
            }, completion: { [weak self] _ in
                guard let self = self else { return }

                self.dimmingBackgroundView?.removeFromSuperview()
                fromViewController.view.removeFromSuperview()

                self.transitionContext?.completeTransition(true)
                self.viewControllerProtocol?.willFinishSwipeDismiss?()
                self.reset()
        })
    }

    private func cancelSwipeDismiss(animated: Bool) {
        guard let context = transitionContext,
            let fromViewController = context.viewController(forKey: .from),
            let toViewController = context.viewController(forKey: .to) else { return }

        context.cancelInteractiveTransition()

        let duration = animated ? transitionDuration(using: transitionContext) : 0

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.3,
            options: [.beginFromCurrentState],
            animations: { [weak self] in
                guard let self = self else { return }
                self.dimmingBackgroundView?.alpha = 1
                fromViewController.view.transform = .identity
            }, completion: { [weak self] _ in
                guard let self = self else { return }

                self.dimmingBackgroundView?.removeFromSuperview()
                toViewController.view.removeFromSuperview()

                self.transitionContext?.completeTransition(false)
                self.reset()

                self.viewControllerProtocol?.didCancelSwipeDismiss?()
        })
    }

    private func updateSwipeDismiss(_ translationY: CGFloat) {
        guard let context = transitionContext,
            let fromViewController = context.viewController(forKey: .from) else { return }

        progress = (translationY / fromViewController.view.height).boundary(minimum: 0, maximum: 1)
        context.updateInteractiveTransition(progress)

        fromViewController.view.transform = .init(translationX: 0, y: translationY)

        let dimmingProgress = min(1, progress / progressThreshold)
        let dimmingAlpha = 1 - dimmingProgress

        dimmingBackgroundView?.alpha = dimmingAlpha

        guard let scrollView = panningView as? UIScrollView else { return }
        let minContentOffsetY = -scrollView.backportContentInset.top
        scrollView.contentOffset.y = minContentOffsetY
    }

    private func reset() {
        isBegan = false
        beginTranslationY = 0
        progress = 0
        transitionContext = nil
        dimmingBackgroundView = nil
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SwipeDismissTransitioningDelegate: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else { return true }

        let velocity = panGesture.velocity(in: panGesture.view)
        return abs(velocity.y) > abs(velocity.x)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension SwipeDismissTransitioningDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return isBegan ? self : nil
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isBegan ? self : nil
    }
}

// MARK: - UIViewControllerInteractiveTransitioning

extension SwipeDismissTransitioningDelegate: UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext

        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else { return }

        let containerView = transitionContext.containerView

        toViewController.view.frame = containerView.bounds
        containerView.addSubview(toViewController.view)

        let dimmingBackgroundView: UIView = {
            if let backgroundView = viewControllerProtocol?.dimmingBackgroundViewForSwipeDismiss {
                return backgroundView
            }
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            return backgroundView
        }()

        containerView.addSubview(dimmingBackgroundView)
        dimmingBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        dimmingBackgroundView.allConstraints(equalTo: containerView).activate()
        self.dimmingBackgroundView = dimmingBackgroundView

        fromViewController.view.frame = containerView.bounds
        containerView.addSubview(fromViewController.view)
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension SwipeDismissTransitioningDelegate: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) { }
}
