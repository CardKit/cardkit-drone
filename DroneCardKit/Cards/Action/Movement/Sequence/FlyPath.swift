//
//  FlyPath.swift
//  DroneCardKit
//
//  Created by ismails on 2/17/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class FlyPath: ExecutableActionCard {
    
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken,
            let path: DCKCoordinate2DPath = self.value(forInput: "Path")
            else {
                return
        }
        
        let altitude: DCKRelativeAltitude? = self.optionalValue(forInput: "Altitude")
        let speed: DCKSpeed? = self.optionalValue(forInput: "Speed")
        let duration: Double? = self.optionalValue(forInput: "Duration")
        
        do {
            // take of to the provided altitude
            if !isCancelled {
                try drone.takeOff(at: altitude)
            }
            
            // fly path
            for (index, location) in path.path.enumerated() {
                if !isCancelled {
                    try drone.fly(to: location, atSpeed: speed)
                } else {
                    break
                }
                
                if !isCancelled && index < path.path.count-1 {
                    Thread.sleep(forTimeInterval: duration ?? 1.0)
                } else if isCancelled {
                    break
                }
            }
        } catch let error {
            self.error(error)
            
            if !isCancelled {
                cancel()
            }
        }
    }
    
    override public func cancel() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            return
        }
        
        do {
            try drone.land()
        } catch let error {
            self.error(error)
        }
    }
}
