//
//  FlyForward.swift
//  DroneCardKit
//
//  Created by ismails on 2/21/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import Foundation

import CardKitRuntime

public class FlyForward: ExecutableActionCard {
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            return
        }
        
        guard let distance: DCKDistance = self.value(forInput: "Distance") else {
            return
        }
        
        let speed: DCKSpeed? = self.optionalValue(forInput: "Speed")
        
        do {
            if !isCancelled {
                guard let currentAttitude = drone.currentAttitude else {
                    throw DroneTokenError.failureRetrievingDroneState
                }
                
                let yaw = currentAttitude.yaw
                let theta = 0
                
                if yaw == 0 {
                    
                }
                
                if (yaw < 90) || (yaw > 180 && yaw < 270)
                
                if yaw > 90 {
                    theta = yaw % 90
                }
                
                let hypotenuse = distance.meters
                let opposite = hypotenuse * sin(theta)
                let
                
                try drone.hover(at: altitude)
            }
        } catch {
            self.error = error
            
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
            if self.error == nil {
                self.error = error
            }
        }
    }
    
    private func calculateXY(using: DCKCoordinate2D, distance: DCKDistance, yaw: DCKAngle) -> (Double, Double) {
        let yawInDegrees = yaw.degrees
        let distanceInMeters = distance.meters
        
        // handle 0, 90, 180, 270
        if yawInDegrees == 0 {
            return (0, distanceInMeters)
        } else if yawInDegrees == 90 {
            return (distanceInMeters, 0)
        } else if yawInDegrees == 180 {
            return (0, -1*distanceInMeters)
        } else if yawInDegrees == 270 {
            return (-1*distanceInMeters, 0)
        }
        
        let relativeYaw = yawInDegrees % 90
        if (yawInDegrees < 90) || (yawInDegrees > 180 && yawInDegrees < 270) {
            // handle first and third quadrants where the opposite value is x, and adjacent is y
        } else {
            // handle second and fourth quadrants where the opposite value is y and adjacent is x
            
        }
        
        return (0,0)
    }
}
