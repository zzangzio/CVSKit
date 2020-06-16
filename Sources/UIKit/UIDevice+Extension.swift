//
//  UIDevice+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

public extension UIDevice {
    static var isPhone: Bool {
        return current.userInterfaceIdiom == .phone
    }

    static var isPad: Bool {
        return current.userInterfaceIdiom == .pad
    }
}
