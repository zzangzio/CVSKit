//
//  UIColor+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(rgb: Int, alpha: CGFloat = 1) {
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat((rgb & 0x0000FF) >> 0) / 255

        if r == g, g == b {
            self.init(white: r, alpha: alpha)
        }
        else {
            self.init(red: r, green: g, blue: b, alpha: alpha)
        }
    }

    public convenience init(argb: UInt32) {
        let alpha = CGFloat((argb & 0xFF000000) >> 24) / 255
        self.init(rgb: numericCast(argb), alpha: alpha)
    }

    public convenience init?(hex: String, alpha: CGFloat = 1) {
        let numericString = hex.replacingOccurrences(of: "#", with: "")
            .replacingOccurrences(of: "0x", with: "")
        guard let rgb = Int(numericString, radix: 16) else { return nil }
        self.init(rgb: rgb, alpha: alpha)
    }
}

