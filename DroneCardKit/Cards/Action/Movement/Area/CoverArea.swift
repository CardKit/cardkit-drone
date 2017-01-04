//
//  CoverArea.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 9/24/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class CoverArea: ExecutableActionCard {
    override public func main() {
        // mandatory inputs
        guard let area: DCKCoordinate2DPath = self.value(forInput: "Area") else {
            return
        }
        
        // optional inputs
        let altitude: DCKRelativeAltitude? = self.optionalValue(forInput: "Altitude")
        let speed: DCKSpeed? = self.optionalValue(forInput: "Speed")
        
        // token
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            return
        }
        
//        firstly {
//            drone.takeOff()
//        }.then {
//            drone.fly(on: area, atAltitude: altitude, atSpeed: speed)
//        }.then {
//            drone.returnHome()
//        }.then {
//            drone.land()
//        }.catch {
//            error in
//            print("error: \(error)")
//            self.error = DroneTokenError.FailureInFlightTriggersLand
//            self.cancel()
//        }
    }
    
    override public func cancel() {
        // token
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            return
        }
        
//        firstly {
//            drone.land()
//        }.catch {
//            error in
//            print("error: \(error)")
//            if self.error == nil {
//                self.error = DroneTokenError.FailureDuringLand
//            }
//        }
    }
}
