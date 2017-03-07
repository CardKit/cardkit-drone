//
//  PointInDirection.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/30/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class PointInDirection: ExecutableAction {
    override public func main() {
        guard let telemetry: TelemetryToken = self.token(named: "Telemetry") as? TelemetryToken,
            let gimbal: GimbalToken = self.token(named: "Gimbal") as? GimbalToken,
            let cardinalDirection: DCKCardinalDirection = self.value(forInput: "CardinalDirection") else {
                return
        }
        
        guard let droneYaw = telemetry.currentAttitude?.yaw else {
            self.error(DroneTokenError.failureRetrievingDroneState)
            return
        }
        
        do {
            if !isCancelled {
                try gimbal.rotate(yaw: droneYaw.normalized() - cardinalDirection.azimuth.normalized(), relativeToDrone: false)
            }
        } catch let error {
            self.error(error)
            
            if !isCancelled {
                cancel()
            }
        }
    }
    
    override public func cancel() {
        // gimbal rotations cannot be cancelled
    }
}
