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

extension UITableView {
    public static func autoLayoutView(_ style: UITableView.Style) -> Self {
        let view = self.init(frame: CGRect.zero, style: style)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }

    public func dequeueReusableCell<Cell: ReusableViewCell>(initializer: (() -> Cell)? = nil) -> Cell {
        if let cell = dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as? Cell {
            return cell
        }

        if let initializer = initializer {
            return initializer()
        }

        return Cell()
    }

    public func dequeueReusableHeaderFooterView<Cell: ReusableViewCell>(initializer: (() -> Cell)? = nil) -> Cell {
        if let cell = dequeueReusableHeaderFooterView(withIdentifier: Cell.reuseIdentifier) as? Cell {
            return cell
        }

        if let initializer = initializer {
            return initializer()
        }

        return Cell()
    }

    public func hideSeparatorsForEmptyRows() {
        let view = UIView()
        view.backgroundColor = .clear
        tableFooterView = view
    }

    public var emptyDataView: UIView? {
        set {
            let beforeView = viewWithTag(hashValue)
            guard beforeView != newValue else { return }

            beforeView?.removeFromSuperview()

            guard let newView = newValue else { return }

            newView.translatesAutoresizingMaskIntoConstraints = false
            newView.tag = hashValue
            addSubview(newView)

            newView.allConstraints(equalTo: backportSafeAreaLayoutGuide).activate()
        }

        get {
            return viewWithTag(hashValue)
        }
    }

    public func optOutSelfSizingCell() {
        estimatedRowHeight = 0
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
    }

    public func reloadData(completion: @escaping (UITableView) -> Void) {
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

    public func beginRefreshing() {
        guard let refreshControl = self.refreshControl else { return }
        refreshControl.beginRefreshing()

        let offsetPoint: CGPoint = {
            if #available(iOS 11, *) {
                return CGPoint.init(x: 0, y: -adjustedContentInset.top)
            }
            return CGPoint.init(x: 0, y: -contentInset.top)
        }()

        setContentOffset(offsetPoint, animated: true)
    }

    public func endRefreshing() {
        guard let refreshControl = self.refreshControl else { return }
        refreshControl.endRefreshing()
    }
}
