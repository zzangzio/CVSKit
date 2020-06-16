//
//  UIEdgeInsets+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 26/11/2018.
//

import UIKit

public extension UIEdgeInsets {
    var horizontal: CGFloat {
        left + right
    }

    var vertical: CGFloat {
        top + bottom
    }

    var leftTop: CGPoint {
        CGPoint(x: left, y: top)
    }

    var rightBottom: CGPoint {
        CGPoint(x: right, y: bottom)
    }
}
