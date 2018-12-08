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
}

extension BinaryFloatingPoint {
    public static func |- (left: Self, right: Self) -> Self {
        return (left - right) / 2
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

