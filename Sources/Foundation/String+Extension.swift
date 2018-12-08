//
//  String+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

// MARK: - Localization
extension String {
    public func localized() -> String {
        return NSLocalizedString(self, comment: self)
    }

    public func localized(with arguments: CVarArg...) -> String {
        if arguments.count == 0 {
            return localized()
        }
        return String(format: localized(), locale: .current, arguments: arguments)
    }
}

extension NSString {
    public var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    public var trimming: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public func toJsonObject() -> Any? {
        guard let data = data(using: String.Encoding.utf8.rawValue) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
}

