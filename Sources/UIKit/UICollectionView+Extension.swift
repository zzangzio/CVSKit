//
//  UICollectionView+Extension.swift
//  CVSKit
//
//  Created by Jaesik Sim on 2020/06/15.
//  Copyright © 2020 zzangzio. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func dequeueReusableCell<Cell: ReusableViewCell>(for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
    }

    func dequeueReusableSupplementaryView<Cell: ReusableViewCell>(
        ofKind kind: String,
        for indexPath: IndexPath
    ) -> Cell {
        return dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: Cell.reuseIdentifier,
            for: indexPath
        ) as! Cell // swiftlint:disable:this force_cast
    }

    func reloadData(completion: @escaping (UICollectionView) -> Void) {
        UIView.animate(
            withDuration: 0, animations: { [weak self] in
                self?.reloadData()
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                completion(self)
            }
        )
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

            newView.allConstraints(equalTo: backportSafeAreaLayoutGuide).activate()
        }

        get {
            return viewWithTag(hashValue)
        }
    }

    func beginRefreshing() {
        guard let refreshControl = self.refreshControl else { return }
        refreshControl.beginRefreshing()

        let offsetPoint = CGPoint.init(x: 0, y: -adjustedContentInset.top)
        setContentOffset(offsetPoint, animated: true)
    }

    func endRefreshing() {
        guard let refreshControl = self.refreshControl else { return }
        refreshControl.endRefreshing()
    }
}
