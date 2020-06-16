//
//  Collection+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 26/11/2018.
//

import UIKit

public extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }

    var any: Element? {
        let aCount = UInt32(count)
        guard aCount > 0 else { return nil }

        return self[Int(arc4random_uniform(aCount))]
    }
}

public extension Collection {
    func forEachStop(_ body: (Element, Int, inout Bool) throws -> Void) rethrows {
        let enumerate = enumerated()
        for (index, value) in enumerate {
            var stop = false
            try body(value, index, &stop)

            if stop { break }
        }
    }
}

public extension Dictionary {
    static func += (left: inout [Key: Value], right: [Key: Value]) {
        for (k, v) in right {
            left.updateValue(v, forKey: k)
        }
    }

    static func + (left: [Key: Value], right: [Key: Value]) -> [Key: Value] {
        var merged = [Key: Value]()
        for (k, v) in left {
            merged[k] = v
        }

        merged += right
        return merged
    }
}

// public func += <K, V> (left: inout [K:V], right: [K:V]) {
//    for (k, v) in right {
//        left.updateValue(v, forKey: k)
//    }
// }
//
// public func + <K, V> (left: [K:V], right: [K:V]) -> [K:V] {
//    var merged = [K:V]()
//    for (k, v) in left {
//        merged[k] = v
//    }
//    merged += right
//    return merged
// }

// MARK: - Json

public extension Array {
    func toJson(prettyPrint: Bool = false) -> String? {
        guard let data = toJsonData(prettyPrint: prettyPrint) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func toJsonData(prettyPrint: Bool = false) -> Data? {
        let options: JSONSerialization.WritingOptions = prettyPrint ? .prettyPrinted : []

        return {
            do {
                return try JSONSerialization.data(withJSONObject: self, options: options)
            } catch {
                print("CVSKit.Array: Error has occurred while converting Array to JSON.")
                return nil
            }
        }()
    }
}

public extension Dictionary {
    func toJson(prettyPrint: Bool = false) -> String? {
        guard let data = toJsonData(prettyPrint: prettyPrint) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func toJsonData(prettyPrint: Bool = false) -> Data? {
        let options: JSONSerialization.WritingOptions = prettyPrint ? .prettyPrinted : []

        return {
            do {
                return try JSONSerialization.data(withJSONObject: self, options: options)
            } catch {
                print("CVSKit.Dictionary: Error has occurred while converting Dictionary to JSON.")
                return nil
            }
        }()
    }
}
