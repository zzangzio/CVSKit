//
//  UIApplication+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2020/09/20.
//  Copyright © 2020 zzangzio. All rights reserved.
//

import UIKit

public extension UIApplication {
    func backgroundTask(withName name: String? = nil) -> (() -> Void)? {
        var id = UIBackgroundTaskIdentifier.invalid
        var didEnd: Int = 0

        let expirationHandler: () -> Void = {
            let didChangeToInvalid = OSAtomicCompareAndSwapLong(0, 1, &didEnd)
            if didChangeToInvalid && id != UIBackgroundTaskIdentifier.invalid {
                UIApplication.shared.endBackgroundTask(id)
            }
        }

        id = beginBackgroundTask(withName: name, expirationHandler: expirationHandler)
        return id != UIBackgroundTaskIdentifier.invalid ? expirationHandler : nil
    }
}
