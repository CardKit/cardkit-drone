//
//  FlyTo.swift
//  DroneCardKit
//
//  Created by Justin Manweiler on 12/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class FlyTo: ExecutableActionCard {
    
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        guard let location: DCKCoordinate2D = self.value(forInput: "Destination") else {
            error = DroneTokenError.MandatoryInputAquisitionFailed
            return
        }
        
        let altitude: DCKRelativeAltitude? = self.optionalValue(forInput: "Altitude")
        let speed: DCKSpeed? = self.optionalValue(forInput: "Speed")
        
        if shouldExecute {
            let semaphore = DispatchSemaphore(value: 0)
            
            drone.turnMotorsOn { error in
                self.error = error
                semaphore.signal()
            }
            
            semaphore.wait()
        }
        
        if shouldExecute {
            let semaphore = DispatchSemaphore(value: 0)
            
            drone.fly(to: location, atYaw: nil, atAltitude: altitude, atSpeed: speed) { error in
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
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
    
        do {
            let semaphore = DispatchSemaphore(value: 0)
            
            drone.land { error in
                self.error = error
                semaphore.signal()
            }
            
            semaphore.wait()
        }
        
        if error == nil {
            let semaphore = DispatchSemaphore(value: 0)
            
            drone.turnMotorsOff { error in
                self.error = error
                semaphore.signal()
            }
            
            semaphore.wait()
        }
    }
    
}
