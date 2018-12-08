//
//  UITableView+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

public protocol ReusableViewCell: NSObjectProtocol {
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

            NSLayoutConstraint.activate(newView.allConstraints(equalTo: self))
        }

        get {
            return viewWithTag(hashValue)
        }
    }

    public func reloadData(completion: @escaping (UITableView) -> Void) {
        reloadData()
        setNeedsLayout()
        layoutIfNeeded()
        completion(self)
    }
}
