//
//  PromiseExtension.swift
//  DroneCardKit
//
//  Created by ismails on 12/9/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import PromiseKit

extension Promise {
    static func empty<T>(result: T) -> Promise<T> {
        return Promise<T> { fulfill, reject in
            fulfill(result)
        }
    }
}
