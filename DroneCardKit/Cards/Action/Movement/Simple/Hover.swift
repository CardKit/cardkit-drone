//
//  Hover.swift
//  DroneCardKit
//
//  Created by ismails on 12/7/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class Hover: ExecutableActionCard {
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        let altitudeInMeters: Double? = self.optionalValue(forInput: "Altitude")
        
        do {
            let altitude: DCKRelativeAltitude? =
                altitudeInMeters == nil
                    ? nil
                    : DCKRelativeAltitude(metersAboveGroundAtTakeoff: altitudeInMeters!)

            if !isCancelled {
                try drone.hoverSync(at: altitude)
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
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        do {
            try drone.landSync()
            try drone.spinMotorsSync(on: false)
        }
        catch {
            if self.error == nil {
                self.error = error
            }
        }
    }
}
