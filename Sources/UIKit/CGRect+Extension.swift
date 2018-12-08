//
//  CGRect+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 25/11/2018.
//

import UIKit

extension CGRect {
    public func intersectionRatio(_ r2: CGRect) -> CGFloat {
        let intersection = self.intersection(r2)
        guard intersection.size != .zero else { return 0 }
        return intersection.size.area / size.area
    }
}
