//
//  UIBarButtonItem+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    public func setTitleColor(_ color: UIColor?, for: UIControl.State = .normal) {
        var textAttributes: [NSAttributedString.Key: Any] = {
            self.titleTextAttributes(for: .normal) ?? [:]
        }()
        textAttributes[.foregroundColor] = color
        setTitleTextAttributes(textAttributes, for: .normal)
    }

    public func setTitleFont(_ font: UIFont?, for: UIControl.State = .normal) {
        var textAttributes: [NSAttributedString.Key: Any] = {
            self.titleTextAttributes(for: .normal) ?? [:]
        }()
        textAttributes[NSAttributedString.Key.font] = font
        setTitleTextAttributes(textAttributes, for: .normal)
    }
}
