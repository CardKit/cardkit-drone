//
//  Hover.swift
//  DroneCardKit
//
//  Created by ismails on 12/7/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import PromiseKit

import CardKitRuntime

public class Hover: ExecutableActionCard {
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        let altitudeInMeters: Double? = self.optionalValue(forInput: "Altitude")
        
        if shouldExecute {
            let semaphore = DispatchSemaphore(value: 0)
            
            if let altitude = altitudeInMeters {
                drone.hover(at: altitude, completionHandler: { (error) in
                    self.error = error
                    semaphore.signal()
                })
            } else {            
                drone.hover(completionHandler: { (error) in
                    self.error = error
                    semaphore.signal()
                })
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
