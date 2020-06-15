//
//  LazyLoader.swift
//  CVSKit
//
//  Created by zzangzio on 2020/06/15.
//  Copyright © 2020 zzangzio. All rights reserved.
//

import Foundation

public class LazyLoader<Type>: NSObject {
    private let initializer: () -> (Type)
    public init(initializer: @escaping () -> (Type)) {
        self.initializer = initializer
    }

    public private(set) var optional: Type?

    public var exist: Type {
        return optional ?? {
            let exist = initializer()
            self.optional = exist
            return exist
        }()
    }

    public func unload() {
        optional = nil
    }
}
