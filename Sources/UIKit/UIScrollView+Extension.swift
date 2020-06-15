//
//  UIScrollView+Extension.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 22..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

extension UIScrollView {
    public var backportContentInset: UIEdgeInsets {
        guard #available(iOS 11, *) else { return contentInset }
        return adjustedContentInset
    }

    public var visibleRect: CGRect {
        return CGRect(
            x: contentInset.left + contentOffset.x,
            y: contentInset.top + contentOffset.y,
            width: bounds.width - contentInset.left - contentInset.right,
            height: bounds.height - contentInset.top - contentInset.bottom
        )
    }
}
