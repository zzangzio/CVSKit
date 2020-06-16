//
//  String+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit

// MARK: - Convenience Localization

public extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }

    func localized(with arguments: CVarArg...) -> String {
        if arguments.count == 0 {
            return localized
        }
        return String(format: localized(), locale: .current, arguments: arguments)
    }
}

// MARK: - Convenience UIImage

public extension String {
    var image: UIImage {
        return UIImage(named: self)!
    }
}

public extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    var trimming: String {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    var trimmingTrail: String {
        replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }

    var trimmingLead: String {
        let whitespaceCharacterSet = CharacterSet.whitespacesAndNewlines
        return String(unicodeScalars.drop(while: { whitespaceCharacterSet.contains($0) }))
    }

    func toJsonObject() -> Any? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
}

// MARK: - Filtering

public extension String {
    var filterNumeric: String {
        return replacingOccurrences(of: "[^0-9|-|.]", with: "", options: .regularExpression)
    }

    var toInt: Int? {
        Int(filterNumeric)
    }

    var toFloat: Float? {
        Float(filterNumeric)
    }
}
