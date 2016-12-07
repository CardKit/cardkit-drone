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
            return
        }
        
        guard let location: DCKCoordinate2D = self.value(forInput: "Destination") else {
            return
        }
        
        let altitude: Double? = self.optionalValue(forInput: "Altitude")
        let speed: Double? = self.optionalValue(forInput: "Speed")
        
        firstly {
            drone.fly(to: location, atSpeed: speed)
        }
        
        
        
//        // token
//        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
//            return
//        }
//        
////        let tp : Promise<Void> = Promise { fulfill, reject in
////            if (drone.isFlying()) {
////                
////            }
////            else {
////                 fufill(drone.takeOff(climbingTo: altitude))
////            }
////        }
////
//        
//        
//        // fly!
//        firstly {
//            if !drone.flying() {
//                return drone.takeOff(climbingTo: altitude)
//            }
//            else {
//                
//            }
//            
//            }
//            .then {
//                _ -> Promise<Void> in
//                drone.fly(to: location, atSpeed: speed)
//            }.catch {
//                error in
//                print("error: \(error)")
//        }
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
