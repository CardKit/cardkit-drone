//
//  Land.swift
//  DroneCardKit
//
//  Created by ismails on 12/7/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import PromiseKit

import CardKitRuntime

class Land: ExecutableActionCard {
    
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else { return }
        
        
        let speed: Double? = self.optionalValue(forInput: "Speed")
        
        
        let semaphore = DispatchSemaphore(value: 0)
        
        drone.isFlying().then { (result) -> Promise<Bool> in
            if result {
                return drone.land()
            }
            
            Promise.
            
            return Promise<Bool> { fulfill, reject in
                fulfill(true)
            }
            }.then { (result) -> Promise<Void> in
                if result {
                    // drone landing failed
                    
                }
                
                
        }
        
        
        override public func cancel() {
            
        }
}
