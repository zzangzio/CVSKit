//
//  Collection+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 26/11/2018.
//

import UIKit

extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
    
    public func forEachStop(_ body: (Element, Int, inout Bool) throws -> Void) rethrows {
        let array = self
        for index in (0..<array.count) {
            let each = array[index]
            var stop = false
            try body(each, index, &stop)
            
            if stop { break }
        }
    }
}
