//
//  String+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

// MARK: - Convenience Localization
extension String {
    public var localized: String {
        return NSLocalizedString(self, comment: self)
    }

    public func localized(with arguments: CVarArg...) -> String {
        if arguments.count == 0 {
            return localized
        }
        return String(format: localized(), locale: .current, arguments: arguments)
    }
}

// MARK: - Convenience UIImage
extension String {
    public var image: UIImage {
        return UIImage(named: self)!
    }
}

extension String {
    public var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    public var trimming: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public func toJsonObject() -> Any? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
}

