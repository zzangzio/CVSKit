//
//  ChatViewSizeCalculator.swift
//  CVSKit
//
//  Created by zzangzio on 2020/06/15.
//  Copyright © 2020 zzangzio. All rights reserved.
//

import UIKit

public class ChatViewSizeCalculator {
    private class Item: NSObject {
        let view: UIView
        let widthConstraint: NSLayoutConstraint

        init(view: UIView) {
            self.view = view
            widthConstraint = (view.widthAnchor <= 0)
            widthConstraint.isActive = true
        }
    }

    private let sizingViewCache = NSCache<NSString, Item>()

    public func viewSize<SizingView: UIView>(
        viewClass: SizingView.Type,
        initializer: (() -> SizingView)? = nil,
        maximumWidth: CGFloat,
        configureHandler: ((SizingView) -> Void)?
    ) -> CGSize {
        let className = String(describing: viewClass) as NSString

        let item = sizingViewCache.object(forKey: className) ?? {
            let item = Item(view: initializer?() ?? viewClass.autoLayoutView())
            sizingViewCache.setObject(item, forKey: className)
            return item
        }()

        guard let sizingView = item.view as? SizingView else {
            return .zero
        }

        configureHandler?(sizingView)

        item.widthConstraint.constant = maximumWidth

        let size = sizingView.systemLayoutSizeFitting(
            CGSize(width: maximumWidth, height: UIView.layoutFittingCompressedSize.height)
        )

        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
}
