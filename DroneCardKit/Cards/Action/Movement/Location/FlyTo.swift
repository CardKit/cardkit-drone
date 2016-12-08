//
//  FlyTo.swift
//  DroneCardKit
//
//  Created by Justin Manweiler on 12/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

import PromiseKit

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
        
        let altitude: DCKAltitude? = self.optionalValue(forInput: "Altitude")
        let speed: DCKVelocity? = self.optionalValue(forInput: "Speed")
        
        drone.motors(on: true)
        .then {
            drone.fly(to: location, atAltitude: altitude, atSpeed: speed)
        }.catch { _ in
            self.error = DroneTokenError.FailureInFlightTriggersLand
            
            drone.land().then { _ in
                drone.motors(on: false)
            }.catch { _ in
            }
        }

    }
    
    override public func cancel() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        drone.land().catch { _ in
            self.error = DroneTokenError.FailureDuringLand
        }
    }
}
