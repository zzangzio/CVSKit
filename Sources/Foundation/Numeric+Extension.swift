//
//  Numeric+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 26/11/2018.
//

import UIKit

infix operator |- : AdditionPrecedence

extension BinaryInteger {
    public static func |- (left: Self, right: Self) -> Self {
        return (left - right) / 2
    }

    public var degreesToRadians: Double {
        return Double(self) * Double.pi / 180
    }

    public var radiansToDegrees: Double {
        return Double(self) * 180 / Double.pi
    }
}

extension BinaryFloatingPoint {
    public static func |- (left: Self, right: Self) -> Self {
        return (left - right) / 2
    }

    public var degreesToRadians: Self {
        return self * .pi / 180
    }

    public var radiansToDegrees: Self {
        return self * 180 / .pi
    }
}

extension BinaryInteger {
    public var humanReadableFileSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        formatter.allowsNonnumericFormatting = false
        return formatter.string(fromByteCount: numericCast(self))
    }
}
