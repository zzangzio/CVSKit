//
//  DelayPerformer.swift
//  CVSKit
//
//  Created by zzangzio on 2020/06/15.
//  Copyright © 2020 zzangzio. All rights reserved.
//

import Foundation

public class DelayPerformer: NSObject {
    private var workItem: DispatchWorkItem?
    private let defaultDelay: TimeInterval

    public init(defaultDelay: TimeInterval) {
        self.defaultDelay = defaultDelay
    }

    public func perform(_ block: @escaping () -> Void) {
        perform(withDelay: defaultDelay, block: block)
    }

    public func perform(withDelay delay: TimeInterval, block: @escaping () -> Void) {
        workItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            block()
            self.workItem = nil
        }
        self.workItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    public func cancel() {
        workItem?.cancel()
        workItem = nil
    }
}
