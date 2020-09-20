//
//  UIScrollView+Extension.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 22..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

public extension UIScrollView {
    var backportContentInset: UIEdgeInsets {
        return adjustedContentInset
    }

    var visibleRect: CGRect {
        return CGRect(
            x: contentInset.left + contentOffset.x,
            y: contentInset.top + contentOffset.y,
            width: bounds.width - contentInset.left - contentInset.right,
            height: bounds.height - contentInset.top - contentInset.bottom
        )
    }
}
