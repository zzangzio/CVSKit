//
//  UIEdgeInsets+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 26/11/2018.
//

import UIKit

extension UIEdgeInsets {
    public var horizontal: CGFloat {
        return left + right
    }
    
    public var vertical: CGFloat {
        return top + bottom
    }
    
    public var leftTop: CGPoint {
        return CGPoint(x: left, y: top)
    }
    
    public var rightBottom: CGPoint {
        return CGPoint(x: right, y: bottom)
    }
}
