//
//  DispatchQueue+Extension.swift
//  CVSKit
//
//  Created by zzangzio on 25/11/2018.
//

import Foundation

extension DispatchQueue {
    public static var userInteractive: DispatchQueue { DispatchQueue.global(qos: .userInteractive) }
    public static var userInitiated: DispatchQueue { DispatchQueue.global(qos: .userInitiated) }
    public static var utility: DispatchQueue { DispatchQueue.global(qos: .utility) }
    public static var background: DispatchQueue { DispatchQueue.global(qos: .background) }
    
    public func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
    public func async<Result>(
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
