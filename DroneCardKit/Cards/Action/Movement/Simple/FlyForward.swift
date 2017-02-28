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
                guard let currentAltitude = drone.currentAltitude,
                    let currentAttitude = drone.currentAttitude,
                    let currentLocation = drone.currentLocation else {
                    throw DroneTokenError.failureRetrievingDroneState
                }
                
                // make an oriented 3D coordinate for the drone's location
                let droneLocation = DCKOrientedCoordinate3D(latitude: currentLocation.latitude, longitude: currentLocation.longitude, altitude: currentAltitude, yaw: currentAttitude.yaw)
                
                let newLocation = droneLocation.add(distance: distance)
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
}