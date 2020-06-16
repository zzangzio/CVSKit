//
//  DispatchQueue+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 25/11/2018.
//

import Foundation

public extension DispatchQueue {
    static var userInteractive: DispatchQueue { DispatchQueue.global(qos: .userInteractive) }
    static var userInitiated: DispatchQueue { DispatchQueue.global(qos: .userInitiated) }
    static var utility: DispatchQueue { DispatchQueue.global(qos: .utility) }
    static var background: DispatchQueue { DispatchQueue.global(qos: .background) }

    func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: closure)
    }

    func async<Result>(
        execute: @escaping () -> Result,
        afterInMain mainExecute: @escaping (Result) -> Void
    ) {
        async {
            let result = execute()
            DispatchQueue.main.async {
                mainExecute(result)
            }
        }
    }
}
