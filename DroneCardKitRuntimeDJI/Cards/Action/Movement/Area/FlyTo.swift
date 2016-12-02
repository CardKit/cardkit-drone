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
        // mandatory inputs
        guard let location: DCKCoordinate2D = self.value(forInput: "Destination") else {
            return
        }
        
        // optional inputs
        let altitude: Double = self.optionalValue(forInput: "Altitude") ?? 2.0
        let speed: Double = self.optionalValue(forInput: "Speed") ?? 2.0
        
        // token
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            return
        }
        
        
        // fly!
        firstly {
            drone.takeOff(climbingTo: altitude)
            }.then {
                _ -> Promise<Void> in
                drone.fly(to: location, atSpeed: speed)
            }.catch {
                error in
                print("error: \(error)")
        }
    }
    
    override public func cancel() {
        // token
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            return
        }
        
        drone.land().catch {
            error in
            print("error: \(error)")
        }
    }
}
