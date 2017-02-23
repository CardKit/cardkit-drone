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
                guard let currentAttitude = drone.currentAttitude,
                    let currentLocation = drone.currentLocation else {
                    throw DroneTokenError.failureRetrievingDroneState
                }
                
                let offsets = calculateXY(distance: distance, yaw: currentAttitude.yaw)
                let newLocation = currentLocation.add(xVal: offsets.0, yVal: offsets.1)
                
                try drone.fly(to: newLocation, atSpeed: speed)
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
    
    private func calculateXY(distance: DCKDistance, yaw: DCKAngle) -> (Double, Double) {
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
        
        // we would like to get the yaw relative to the starting angle of the quadrant (in a unit circle)
        // for example, quadrant 3 starts at 180, if yawInDegrees is 190, we would like to get 10
        var relativeYaw = yawInDegrees.truncatingRemainder(dividingBy: 90)
        
        // now we are make sure the angle is with respect to the x axis
        // using the example above, if we are quadrant 3, and yawInDegrees is 190, we should get 80 (270-190 = 80)
        if yawInDegrees > 0 && yawInDegrees < 90 {
            relativeYaw = 90 - relativeYaw
        } else if yawInDegrees > 180 && yawInDegrees < 270 {
            relativeYaw = 90 - relativeYaw
        }
        
        // with the new relative angles, we can safely say that the opposite side of the triangle is y,
        // the adjacent is x, and the hypotenuse is distanceInMeters
        
        // calculate opposite
        var newY = sin(relativeYaw.degreesToRadians) * distanceInMeters
        
        // calculate adjacent
        var newX = sin(relativeYaw.degreesToRadians) * distanceInMeters
        
        // set signs
        if yawInDegrees > 0 && yawInDegrees < 90 {
            newX = abs(newX)
            newY = abs(newY)
        } else if yawInDegrees > 90 && yawInDegrees < 180 {
            newX = abs(newX)
            newY = -1*newY
        } else if yawInDegrees > 180 && yawInDegrees < 270 {
            newX = -1*newX
            newY = -1*newY
        } else if yawInDegrees > 270 && yawInDegrees < 360 {
            newX = -1*newX
            newY = abs(newY)
        }
        
        return (newX,newY)
    }
}
