//
//  Circle.swift
//  DroneCardKit
//
//  Created by Kyungmin Lee on 1/30/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class Circle: ExecutableAction {
    
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken,
            let center: DCKCoordinate2D = self.value(forInput: "Center"),
            let radius: DCKDistance = self.value(forInput: "Radius"),
            let altitude: DCKRelativeAltitude = self.value(forInput: "Altitude")
            else { return }
        
        let angularSpeed: DCKAngularVelocity? = self.optionalValue(forInput: "AngularSpeed")
        let direction: DCKRotationDirection? = self.optionalValue(forInput: "Direction")
        
        do {
            // take of to the provided altitude
            if !isCancelled {
                try drone.takeOff(at: altitude)
            }
            
            // circle
            if !isCancelled {
                try drone.circle(around: center, atRadius: radius, atAltitude: altitude, atAngularSpeed: angularSpeed, direction: direction, repeatedly: false)
            }
        } catch let error {
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
        } catch let error {
            self.error(error)
        }
    }
}
