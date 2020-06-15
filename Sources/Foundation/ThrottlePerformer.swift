//
//  ThrottlePerformer.swift
//  CVSKit
//
//  Created by zzangzio on 2020/06/15.
//  Copyright © 2020 zzangzio. All rights reserved.

import Foundation

//  Simple throttler which can be used for search keyword input.
//  Source: https://www.craftappco.com/blog/2018/5/30/simple-throttling-in-swift
public class ThrottlePerformer {
    private var workItem = DispatchWorkItem(block: {})
    private var previousRun = Date.distantPast
    private let minimumDelay: TimeInterval

    public init(minimumDelay: TimeInterval) {
        self.minimumDelay = minimumDelay
    }

    public func throttle(_ block: @escaping () -> Void) {
        // Cancel any existing work item if it has not yet executed
        workItem.cancel()

        // Re-assign workItem with the new block task, resetting the previousRun time when it executes
        workItem = DispatchWorkItem(block: {
            [weak self] in
            self?.previousRun = Date()
            block()
        })

        // If the time since the previous run is more than the required minimum delay
        // => execute the workItem immediately
        // else
        // => delay the workItem execution by the minimum delay time
        let delay = -previousRun.timeIntervalSinceNow > minimumDelay ? 0 : minimumDelay
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay), execute: workItem)
    }

    public func cancel() {
        workItem.cancel()
        workItem = DispatchWorkItem(block: {})
    }
}
