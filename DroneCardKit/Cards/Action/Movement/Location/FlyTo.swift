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
        
        firstly {
            drone.turnMotorsOn()
        }.then {
            drone.fly(to: location, atAltitude: altitude, atSpeed: speed)
        }.catch {
            error in
            self.error = DroneTokenError.FailureInFlightTriggersLand
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
