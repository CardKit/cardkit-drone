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
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        guard let location: DCKCoordinate2D = self.value(forInput: "Destination") else {
            self.error = DroneTokenError.MandatoryInputAquisitionFailed
            return
        }
        
        let altitude: DCKRelativeAltitude? = self.optionalValue(forInput: "Altitude")
        let speed: DCKSpeed? = self.optionalValue(forInput: "Speed")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        drone.turnMotorsOn { error in
            self.error = error
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error == nil {
            drone.fly(to: location, atYaw: nil, atAltitude: altitude, atSpeed: speed) { error in
                self.error = error
                semaphore.signal()
            }
            
            semaphore.wait()
        }
        
        if error != nil {
            cancel()
        }
    }
    
    override public func cancel() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        drone.land { error in
            self.error = error
            semaphore.signal()
        }
        
        if error == nil {
            drone.turnMotorsOff { error in
                self.error = error
                semaphore.signal()
            }
        }
        
        semaphore.wait()
    }
}
