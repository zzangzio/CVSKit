//
//  Numeric+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 26/11/2018.
//

import UIKit

infix operator |-: AdditionPrecedence

public extension BinaryInteger {
    static func |- (left: Self, right: Self) -> Self {
        return (left - right) / 2
    }

    var degreesToRadians: Double {
        return Double(self) * Double.pi / 180
    }

    var radiansToDegrees: Double {
        return Double(self) * 180 / Double.pi
    }
}

public extension BinaryFloatingPoint {
    static func |- (left: Self, right: Self) -> Self {
        return (left - right) / 2
    }

    var degreesToRadians: Self {
        return self * .pi / 180
    }

    var radiansToDegrees: Self {
        return self * 180 / .pi
    }
}

public extension BinaryInteger {
    var humanReadableFileSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        formatter.allowsNonnumericFormatting = false
        return formatter.string(fromByteCount: numericCast(self))
    }
}
