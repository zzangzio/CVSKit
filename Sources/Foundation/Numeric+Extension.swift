//
//  Numeric+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 26/11/2018.
//

import UIKit

infix operator |- : AdditionPrecedence

extension BinaryInteger {
    static public func |- (left: Self, right: Self) -> Self {
        return (left - right) / 2
    }
}

extension BinaryFloatingPoint {
    static public func |- (left: Self, right: Self) -> Self {
        return (left - right) / 2
    }
}

