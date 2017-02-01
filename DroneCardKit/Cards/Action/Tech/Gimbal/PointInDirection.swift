//
//  PointInDirection.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/30/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class PointInDirection: ExecutableActionCard {
    override public func main() {
        guard let gimbal: GimbalToken = self.token(named: "Gimbal") as? GimbalToken else {
            return
        }
        
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            return
        }
        
        guard let desiredGimbalYaw: DCKAngle = self.value(forInput: "CardinalDirection") else {
            return
        }
        
        guard let droneYaw = drone.currentAttitude?.yaw else {
            self.error = DroneTokenError.FailureRetrievingDroneState
            return
        }
        
        do {
            if !isCancelled {
                try gimbal.rotateSync(yaw: droneYaw.normalized() - desiredGimbalYaw.normalized(), relative: false)
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
        
        // can we actually cancel the gimbal rotate command?
    }
}
