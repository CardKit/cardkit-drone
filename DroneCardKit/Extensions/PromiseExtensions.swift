//
//  PromiseExtension.swift
//  DroneCardKit
//
//  Created by ismails on 12/9/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import PromiseKit

public extension Promise {
    public static func empty<T>(result: T, execute: (() -> ())? = nil) -> Promise<T> {
        return Promise<T> { fulfill, reject in
            execute?()
            fulfill(result)
        }
    }
    
    public static func empty<T>(result: T, secondsToWait: TimeInterval) -> Promise<T> {
        return Promise.empty(result: result) {
            Thread.sleep(forTimeInterval: secondsToWait)
        }
    }
}
