//
//  TokenDispatch.swift
//  DroneCardKit
//
//  Created by ismails on 1/30/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

public typealias DroneTokenCompletionHandler = (Error?) -> Void

class TokenDispatch {
    static func executeSynchronously(asyncMethod method: (DroneTokenCompletionHandler?) -> Void) throws {
        let semaphore = DispatchSemaphore(value: 0)
        var methodError: Error? = nil
        
        method({
            error in
            methodError = error
            semaphore.signal()
        })
        
        semaphore.wait()
        
        if let error = methodError {
            throw error
        }
    }
}
