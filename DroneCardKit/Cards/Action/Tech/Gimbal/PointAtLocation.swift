//
//  PointAtLocation.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/30/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class PointAtLocation: ExecutableActionCard {
    override public func main() {
        guard let droneTelemetry: DroneTelemetryToken = self.token(named: "DroneTelemetry") as? DroneTelemetryToken else {
            return
        }
        
        guard let gimbal: GimbalToken = self.token(named: "Gimbal") as? GimbalToken else {
            return
        }
        
        guard let desiredLocation: DCKCoordinate3D = self.value(forInput: "Location") else {
            return
        }
        
        guard let currentLocation = droneTelemetry.currentLocation,
            let currentAltitude = droneTelemetry.currentAltitude,
            let currentAttitude = droneTelemetry.currentAttitude else {
            self.error = DroneTokenError.FailureRetrievingDroneState
            return
        }
        
        // make a 3D coordinate for the drone's location
        let droneLocation = DCKCoordinate3D(latitude: currentLocation.latitude, longitude: currentLocation.longitude, altitude: currentAltitude)
        
        // calculate the absolute bearing between the drone and the desiredLocation
        let bearing = droneLocation.bearing(to: desiredLocation)
        
        // calculate the relative bearing between the drone's yaw and the absolute bearing
        let relativeBearing = bearing - currentAttitude.yaw
        
        // normalize the bearing (so negative angles become positive)
        let normalizedRelativeBearing = relativeBearing.normalized()
        
        // calculate the pitch angle needed to orient the gimbal to the desiredLocation
        let pitch = droneLocation.pitch(to: desiredLocation)
        
        do {
            if !isCancelled {
                try gimbal.rotateSync(yaw: normalizedRelativeBearing, pitch: pitch, relative: false)
            }
        } catch {
            self.error = error
            
            if !isCancelled {
                cancel()
            }
        }
    }
    
    override public func cancel() {
        // gimbal rotations cannot be cancelled
    }
}
