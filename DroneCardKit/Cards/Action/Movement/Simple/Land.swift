//
//  Land.swift
//  DroneCardKit
//
//  Created by ismails on 12/7/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class Land: ExecutableActionCard {
    
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        let _: Double? = self.optionalValue(forInput: "Speed")
        
        if shouldExecute {
            let semaphore = DispatchSemaphore(value: 0)
            
            drone.land { error in
                self.error = error
                semaphore.signal()
            }
            
            semaphore.wait()
        }
        
        if shouldExecute {
            let semaphore = DispatchSemaphore(value: 0)
            
            drone.turnMotorsOff { error in
                self.error = error
                semaphore.signal()
            }
            
            semaphore.wait()
        }
        
        if shouldCancel {
            cancel()
        }
    }
    
    override public func cancel() {
    }
    
}
