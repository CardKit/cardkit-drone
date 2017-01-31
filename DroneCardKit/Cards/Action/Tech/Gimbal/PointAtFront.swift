//
//  PointAtFront.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/30/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class PointAtFront: ExecutableActionCard {
    override public func main() {
        guard let gimbal: GimbalToken = self.token(named: "Gimbal") as? GimbalToken else {
            return
        }
        
        do {
            if !isCancelled {
                try gimbal.rotateSync(yaw: DCKAngle.zero, pitch: DCKAngle.zero, roll: DCKAngle.zero, relative: false)
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
