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
        
        do {
            if !isCancelled {
                try drone.landSync()
            }
        
            if !isCancelled {
                try drone.spinMotorsSync(on: false)
            }
        }
        catch {
            self.error = error
            
            if !isCancelled {
                cancel()
            }
        }
    }
    
    override public func cancel() {
    }
    
}
