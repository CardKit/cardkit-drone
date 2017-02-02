//
//  PanBetweenLocations.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/30/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class PanBetweenLocations: ExecutableActionCard {
    override public func main() {
        guard let droneTelemetry: DroneTelemetryToken = self.token(named: "DroneTelemetry") as? DroneTelemetryToken else {
            return
        }
        
        guard let gimbal: GimbalToken = self.token(named: "Gimbal") as? GimbalToken else {
            return
        }
        
        guard let startLocation: DCKCoordinate3D = self.value(forInput: "StartLocation") else {
            return
        }
        
        guard let endLocation: DCKCoordinate3D = self.value(forInput: "EndLocation") else {
            return
        }
        
        // rotate to the start location
        var currentLocation: LocationChoice = .start
        
        
        // pan between locations until we are finished executing
        while !self.isCancelled {
            // get the current location of the drone
            
        }
        
        guard let currentLocation = droneTelemetry.currentLocation,
            let currentAltitude = droneTelemetry.currentAltitude,
            let currentDroneAttitude = droneTelemetry.currentAttitude else {
                self.error = DroneTokenError.FailureRetrievingDroneState
                return
        }
        
        // calculate yaw movement
        let bearing = currentLocation.bearingTo(secondCoordinate: desiredLocation.as2D()).degrees
        
        // bearing relative to current drone attitude
        let relativeBearing = bearing - currentDroneAttitude.yaw.degrees
        let yawAngleNormalized = DCKAngle(degrees: relativeBearing).normalized()
        
        // using sohcahtoa to calculate the change in pitch
        // we have the opposite value (change in altitude) and the hypotoneuse (distance to location)
        // sin(theta) = opposite/hypotoneuse .. which is..  sin(theta) = altitude/distance
        let altitudeDelta = desiredLocation.altitude.metersAboveGroundAtTakeoff - currentAltitude.metersAboveGroundAtTakeoff
        let distanceToLocation = currentLocation.distanceTo(secondCoordinate: desiredLocation.as2D())
        
        let pitchAngle = asin(altitudeDelta/distanceToLocation)
        let pitchAngleNormalized = DCKAngle(degrees: pitchAngle).normalized()
        
        do {
            if !isCancelled {
                try gimbal.rotateSync(yaw: yawAngleNormalized, pitch: pitchAngleNormalized, relative: false)
            }
        } catch {
            self.error = error
            
            if !isCancelled {
                cancel()
            }
        }
    }
    
    override public func cancel() {
        // panning will stop automatically when cancel() is called
    }
}

fileprivate enum LocationChoice {
    case start
    case end
}
