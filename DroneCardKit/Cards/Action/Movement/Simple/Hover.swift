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

class Hover: ExecutableActionCard {
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        let altitudeInMeters: Double? = self.optionalValue(forInput: "Altitude")
        
        let hover: Promise<Void>
        
        if let altitude = altitudeInMeters {
            hover =
                firstly {
                    drone.orient(to: DCKAltitude(metersAboveSeaLevel: altitude))
                }.then {
                    drone.hover()
                }
        } else {
            hover = drone.hover()
        }
        
        firstly {
            hover
        }.catch {
            error in
            self.error = DroneTokenError.FailureDuringHover
            self.cancel()
        }
    }
    
    override public func cancel() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        firstly {
            drone.land()
        }.then {
            drone.turnMotorsOff()
        }.catch {
            _ in
            if self.error == nil {
                self.error = DroneTokenError.FailureDuringLand
            }
        }
    }
}
