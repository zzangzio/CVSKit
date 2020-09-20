//
//  UITableView+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

public protocol ReusableViewCell {
    static var reuseIdentifier: String { get }

    init()
}

public extension UITableView {
    static func autoLayoutView(_ style: UITableView.Style) -> Self {
        let view = self.init(frame: CGRect.zero, style: style)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }

    func dequeueReusableCell<Cell: ReusableViewCell>(initializer: (() -> Cell)? = nil) -> Cell {
        if let cell = dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as? Cell {
            return cell
        }

        if let initializer = initializer {
            return initializer()
        }

        return Cell()
    }

    func dequeueReusableHeaderFooterView<Cell: ReusableViewCell>(initializer: (() -> Cell)? = nil) -> Cell {
        if let cell = dequeueReusableHeaderFooterView(withIdentifier: Cell.reuseIdentifier) as? Cell {
            return cell
        }

        if let initializer = initializer {
            return initializer()
        }

        return Cell()
    }

    func hideSeparatorsForEmptyRows() {
        let view = UIView()
        view.backgroundColor = .clear
        tableFooterView = view
    }

    var emptyDataView: UIView? {
        set {
            let beforeView = viewWithTag(hashValue)
            guard beforeView != newValue else { return }

            beforeView?.removeFromSuperview()

            guard let newView = newValue else { return }

            newView.translatesAutoresizingMaskIntoConstraints = false
            newView.tag = hashValue
            addSubview(newView)

            newView.allConstraints(equalTo: safeAreaLayoutGuide).activate()
        }

        get {
            return viewWithTag(hashValue)
        }
    }

    func optOutSelfSizingCell() {
        estimatedRowHeight = 0
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
    }

    func reloadData(completion: @escaping (UITableView) -> Void) {
        UIView.animate(
            withDuration: 0,
            animations: { [weak self] in
                self?.reloadData()
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                completion(self)
            }
        )
    }

    func beginRefreshing() {
        guard let refreshControl = self.refreshControl else { return }
        refreshControl.beginRefreshing()

        let offsetPoint = CGPoint(x: 0, y: -adjustedContentInset.top)

        setContentOffset(offsetPoint, animated: true)
    }

    func endRefreshing() {
        guard let refreshControl = self.refreshControl else { return }
        refreshControl.endRefreshing()
    }
}
