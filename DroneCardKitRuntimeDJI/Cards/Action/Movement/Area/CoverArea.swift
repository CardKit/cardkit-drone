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
    // tokens
    var drone: DroneToken? = nil
    
    override public func main() {
        // mandatory inputs
        var area: DCKCoordinate3DPath
        
        do {
            let value: DCKCoordinate3DPath = try self.value(forInput: "Area")
            area = value
        } catch let error {
            if let e = error as? ActionExecutionError {
                self.error = e
            }
            return
        }
        
        // optional inputs
        let altitude: Double = self.optionalValue(forInput: "Altitude") ?? 2.0
        let speed: Double = self.optionalValue(forInput: "Speed") ?? 2.0
        
        // token
        do {
            let executable: ExecutableTokenCard = try self.token(named: "Drone")
            
            if let droneToken = executable as? DroneToken {
                self.drone = droneToken
            } else {
                return
            }
            
        } catch let error {
            if let e = error as? ActionExecutionError {
                self.error = e
            }
            return
        }
        
        guard let drone = self.drone else {
            return
        }
        
        // fly!
        drone.takeOff(climbingTo: altitude)
        for point in area.path {
            drone.fly(to: point, atSpeed: speed)
        }
        drone.returnHome()
        drone.land()
    }
    
    override public func cancel() {
        guard let drone = self.drone else {
            return
        }
        drone.land()
    }
}
