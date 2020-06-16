//
//  ChameleonViewPlaygroundViewController.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 15..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import CVSKit
import UIKit

class ChameleonViewPlaygroundViewController: PlaygroundViewController {
    override class var playgroundTitle: String {
        return "Changing color with interaction"
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

    private let chameleonView: ChameleonView = {
        let chameleonView = ChameleonView.autoLayoutView()

        return chameleonView
    }()

    private let pagingView: HorizontalPagingView = {
        let pagingView = HorizontalPagingView.autoLayoutView()
        let redView = UILabel(font: UIFont.boldSystemFont(ofSize: 30), color: .white)
        redView.tag = 0xFFFF0000
        redView.textAlignment = .center
        redView.text = "Red"

        let yellowView = UILabel(font: UIFont.boldSystemFont(ofSize: 30), color: .white)
        yellowView.tag = 0xFFFFFF00
        yellowView.textAlignment = .center
        yellowView.text = "Yellow"

        let greenView = UILabel(font: UIFont.boldSystemFont(ofSize: 30), color: .white)
        greenView.tag = 0xFF00FF00
        greenView.textAlignment = .center
        greenView.text = "Green"

        let cyanView = UILabel(font: UIFont.boldSystemFont(ofSize: 30), color: .white)
        cyanView.tag = 0xFF00FFFF
        cyanView.textAlignment = .center
        cyanView.text = "Cyan"

        let blueView = UILabel(font: UIFont.boldSystemFont(ofSize: 30), color: .white)
        blueView.tag = 0xFF0000FF
        blueView.textAlignment = .center
        blueView.text = "Blue"

        let magentaView = UILabel(font: UIFont.boldSystemFont(ofSize: 30), color: .white)
        magentaView.tag = 0xFFFF00FF
        magentaView.textAlignment = .center
        magentaView.text = "Magenta"

        pagingView.pages = [redView, yellowView, greenView, cyanView, blueView, magentaView]

        return pagingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(chameleonView)
        view.addSubview(tabControlView)
        view.addSubview(pagingView)
        pagingView.pagingDelegate = self

        tabControlView.titles = pagingView.pages.map { each -> String in
            (each as? UILabel)?.text ?? ""
        }

        tabControlView.delegate = self

        let layoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate(
            [
                tabControlView.topAnchor |= layoutGuide.topAnchor,
                tabControlView.heightAnchor |= 45,
                tabControlView.leadingAnchor |= view.leadingAnchor,
                tabControlView.trailingAnchor |= view.trailingAnchor,
                chameleonView.topAnchor |= view.topAnchor,
                chameleonView.bottomAnchor |= view.bottomAnchor,
                chameleonView.leadingAnchor |= view.leadingAnchor,
                chameleonView.trailingAnchor |= view.trailingAnchor,
                pagingView.topAnchor |= tabControlView.bottomAnchor,
                pagingView.bottomAnchor |= view.bottomAnchor,
                pagingView.leadingAnchor |= view.leadingAnchor,
                pagingView.trailingAnchor |= view.trailingAnchor,
            ])
    }

    private var tempPageIndex: Int = 0
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tempPageIndex = pagingView.pageIndex
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.layoutIfNeeded()
        pagingView.setPage(at: tempPageIndex, animated: false)

        let width = view.width

        chameleonView.minFeel = 0
        chameleonView.maxFeel = width * CGFloat(pagingView.pages.count)

        chameleonView.set(argbAndLocations: pagingView.pages.map { (UInt32($0.tag), $0.frame.minX) })
        chameleonView.feel = pagingView.contentOffset.x
    }
}

// MARK: - HorizontalPagingViewDelegate

extension ChameleonViewPlaygroundViewController: HorizontalPagingViewDelegate {
    func horizontalPagingView(_ pagingView: HorizontalPagingView, didChangePage _: Int) {
        chameleonView.feel = pagingView.contentOffset.x
    }

    func scrollViewDidScroll(_: UIScrollView) {
        chameleonView.feel = pagingView.contentOffset.x

        guard pagingView.isUserInteractionEnabled else { return }
        let progressIndex = pagingView.contentOffset.x / pagingView.width
        tabControlView.setProgressIndex(progressIndex, animated: false)
    }

    func scrollViewWillBeginDragging(_: UIScrollView) {
        tabControlView.isUserInteractionEnabled = false
    }

    func scrollViewDidEndDecelerating(_: UIScrollView) {
        tabControlView.isUserInteractionEnabled = true
    }

    func scrollViewDidEndScrollingAnimation(_: UIScrollView) {
        pagingView.isUserInteractionEnabled = true
    }

    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            tabControlView.isUserInteractionEnabled = true
        }
    }
}

// MARK: - TabControlViewDelegate

extension ChameleonViewPlaygroundViewController: TabControlViewDelegate {
    func tabControlView(_: TabControlView,
                        didChangeIndex index: Int,
                        by: TabControlViewChangedBy) {
        guard by != .progress else { return }
        pagingView.isUserInteractionEnabled = false
        pagingView.setPage(at: index, animated: true)
    }
}
