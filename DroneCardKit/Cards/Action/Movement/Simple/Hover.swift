//
//  Hover.swift
//  DroneCardKit
//
//  Created by ismails on 12/7/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class Hover: ExecutableAction {
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            return
        }
        
        let altitude: DCKRelativeAltitude? = self.optionalValue(forInput: "Altitude")
        
        do {
            if !isCancelled {
                try drone.hover(at: altitude)
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
