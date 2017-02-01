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
        
        guard let location: Bool = self.value(forInput: "Location") else {
            return
        }
        
        // figure out the right angle at which to point
//        let droneLocation: DCKCoordinate3D = drone.currentLocation
        
        do {
            if !isCancelled {
                try gimbal.rotateSync(yaw: DCKAngle.zero, pitch: DCKAngle.zero, roll: DCKAngle.zero, relative: true)
            }
        } catch {
            self.error = error
            
            if !isCancelled {
                cancel()
            }
        }
    }
    
    override public func cancel() {
        guard let _: GimbalToken = self.token(named: "Gimbal") as? GimbalToken else {
            return
        }
        
        // TODO can we actually cancel the gimbal rotate command?
    }
}
