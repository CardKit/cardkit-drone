//
//  CircleRepeatedly.swift
//  DroneCardKit
//
//  Created by Kyungmin Lee on 2/3/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class CircleRepeatedly: ExecutableAction {
    
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken,
            let center: DCKCoordinate2D = self.value(forInput: "Center"),
            let radius: DCKDistance = self.value(forInput: "Radius"),
            let altitude: DCKRelativeAltitude = self.value(forInput: "Altitude")
            else { return }
        
        let angularVelocity: DCKAngularVelocity? = self.optionalValue(forInput: "AngularVelocity")
        let direction: DCKRotationDirection? = self.optionalValue(forInput: "Direction")
        
        do {
            // take of to the provided altitude
            if !isCancelled {
                try drone.takeOff(at: altitude)
            }
            
            // circle
            if !isCancelled {
                try drone.circle(around: center, atRadius: radius, atAltitude: altitude, atAngularVelocity: angularVelocity, direction: direction, repeatedly: true)
            }
        } catch {
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
        } catch {
            self.error(error)
        }
    }
    
}
