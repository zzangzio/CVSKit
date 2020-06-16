//
//  SensitiveControl.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

open class SensitiveButton: UIButton {
    public let hitTester = SensitiveHitTester()

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return hitTester.point(inside: point, bounds: bounds, with: event)
    }
}

open class SensitiveHitTester: NSObject {
    public var extraHitEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    func point(inside point: CGPoint, bounds: CGRect, with _: UIEvent?) -> Bool {
        var rect = bounds
        rect.origin.x -= extraHitEdgeInsets.left
        rect.origin.y -= extraHitEdgeInsets.top
        rect.size.width += extraHitEdgeInsets.horizontal
        rect.size.height += extraHitEdgeInsets.vertical
        return rect.contains(point)
    }
}
