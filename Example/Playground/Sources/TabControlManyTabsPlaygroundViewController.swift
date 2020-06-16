//
//  TabControlManyTabsPlaygroundViewController.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 15..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import CVSKit
import UIKit

class TabControlManyTabsPlaygroundViewController: PlaygroundViewController {
    override class var playgroundTitle: String {
        return "TabControl with many tabs"
    }

    private let tabControlView: TabControlView = {
        let tabControlView = TabControlView.autoLayoutView()
        tabControlView.sideMargin = 50
        tabControlView.backgroundColor = .white
        tabControlView.isExclusiveTouch = true
        tabControlView.bottomLine(1, out: false) { view in
            view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }
        return tabControlView
    }()

    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    private lazy var pageScrollView: UIScrollView = {
        pageViewController.view.subviews.first { $0 is UIScrollView } as! UIScrollView
    }()

    private let viewControllers: [UIViewController] = {
        let redVC = UIViewController(nibName: nil, bundle: nil)
        redVC.title = "red"
        redVC.view.backgroundColor = .red

        let yellowVC = UIViewController(nibName: nil, bundle: nil)
        yellowVC.title = "yellow"
        yellowVC.view.backgroundColor = .yellow

        let greenVC = UIViewController(nibName: nil, bundle: nil)
        greenVC.title = "green"
        greenVC.view.backgroundColor = .green

        let cyanVC = UIViewController(nibName: nil, bundle: nil)
        cyanVC.title = "cyan"
        cyanVC.view.backgroundColor = .cyan

        let blueVC = UIViewController(nibName: nil, bundle: nil)
        blueVC.title = "blue"
        blueVC.view.backgroundColor = .blue

        let magentaVC = UIViewController(nibName: nil, bundle: nil)
        magentaVC.title = "magenta"
        magentaVC.view.backgroundColor = .magenta

        return [redVC, yellowVC, greenVC, cyanVC, blueVC, magentaVC]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view!

        view.backgroundColor = .white

        pageViewController.dataSource = self
        pageScrollView.delegate = self

        addChild(pageViewController)
        view.addSubview(pageViewController.view)

        pageViewController.setViewControllers(
            [viewControllers[0]],
            direction: .forward,
            animated: true,
            completion: nil
        )

        view.addSubview(tabControlView)
        tabControlView.titles = viewControllers.map { $0.title! }
        tabControlView.delegate = self

        let pageView = pageViewController.view!
        pageView.translatesAutoresizingMaskIntoConstraints = false
        pageView.isExclusiveTouch = true
        let layoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate(
            [
                tabControlView.topAnchor |= layoutGuide.topAnchor,
                tabControlView.heightAnchor |= 45,
                tabControlView.leadingAnchor |= view.leadingAnchor,
                tabControlView.trailingAnchor |= view.trailingAnchor,
                pageView.topAnchor |= tabControlView.bottomAnchor,
                pageView.bottomAnchor |= view.bottomAnchor,
                pageView.leadingAnchor |= view.leadingAnchor,
                pageView.trailingAnchor |= view.trailingAnchor,
            ])
    }
}

// MARK: - UIPageViewControllerDataSource

extension TabControlManyTabsPlaygroundViewController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        return viewControllers[safe: index + 1]
    }

    func pageViewController(_: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        return viewControllers[safe: index - 1]
    }
}

// MARK: - TabControlViewDelegate

extension TabControlManyTabsPlaygroundViewController: TabControlViewDelegate {
    func tabControlView(_ tabControlView: TabControlView,
                        didChangeIndex index: Int, by: TabControlViewChangedBy) {
        guard by != .progress else { return }
        guard let viewController = pageViewController.viewControllers?[safe: 0] else { return }
        guard let currentIndex = viewControllers.firstIndex(of: viewController) else { return }
        guard currentIndex != index else { return }

        let direction: UIPageViewController.NavigationDirection = {
            switch (UIView.isRightToLeft, currentIndex > index) {
            case (true, true):
                return .forward
            case (true, false):
                return .reverse
            case (false, true):
                return .reverse
            case (false, false):
                return .forward
            }
        }()

        tabControlView.isUserInteractionEnabled = false
        pageViewController.view.isUserInteractionEnabled = false
        pageViewController.setViewControllers(
            [viewControllers[index]],
            direction: direction,
            animated: true
        ) { _ in
            DispatchQueue.main.after(0.2, execute: { [weak self] in
                guard let self = self else { return }
                self.tabControlView.isUserInteractionEnabled = true
                self.pageViewController.view.isUserInteractionEnabled = true
                })
        }
    }
}

// MARK: - UIScrollViewDelegate

extension TabControlManyTabsPlaygroundViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard pageViewController.view.isUserInteractionEnabled else { return }
        let contentOffset = scrollView.contentOffset
        let percentComplete = ((contentOffset.x - scrollView.width) / scrollView.width)
        tabControlView.setProgress(percentComplete, animated: false)
    }

    func scrollViewWillBeginDragging(_: UIScrollView) {
        tabControlView.isUserInteractionEnabled = false
    }

    func scrollViewDidEndDecelerating(_: UIScrollView) {
        tabControlView.isUserInteractionEnabled = true
    }

    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            tabControlView.isUserInteractionEnabled = true
        }
    }
}
