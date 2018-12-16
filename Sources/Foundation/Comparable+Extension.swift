//
//  Comparable+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 15..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import Foundation

extension Comparable {
    public func boundary(minimum: Self, maximum: Self) -> Self {
        return max(minimum, min(maximum, self))
    }
}
