//
//  OptionSet+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import Swift

public extension OptionSet where RawValue: FixedWidthInteger {
    func forEach(_ body: (Self) throws -> Void) rethrows {
        for each in enumerate() {
            try body(each)
        }
    }

    func reduce<Result>(_ initialResult: Result, _
        nextPartialResult: (Result, Self) throws -> Result) rethrows -> Result {
        var result: Result = initialResult

        try forEach { each in
            result = try nextPartialResult(result, each)
        }

        return result
    }

    func enumerate() -> AnySequence<Self> {
        var remainingBits = rawValue
        var bitMask: RawValue = 1
        return AnySequence {
            AnyIterator {
                while remainingBits != 0 {
                    defer { bitMask = bitMask &* 2 }
                    if remainingBits & bitMask != 0 {
                        remainingBits = remainingBits & ~bitMask
                        return Self(rawValue: bitMask)
                    }
                }
                return nil
            }
        }
    }
}
