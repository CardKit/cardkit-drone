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
        
        let framerate: VideoFramerate? = self.optionalValue(forInput: "Framerate")
        let resolution: VideoResolution? = self.optionalValue(forInput: "Resolution")
        let slowmo: Bool? = self.optionalValue(forInput: "SlowMotionEnabled")
        
        var cameraOptions: Set<CameraVideoOption> = []
        if let framerate = framerate {
            cameraOptions.insert(.framerate(framerate))
        }
        if let resolution = resolution {
            cameraOptions.insert(.resolution(resolution))
        }
        if let _ = slowmo {
            cameraOptions.insert(.slowMotionEnabled)
        }
        
        do {
            if !isCancelled {
                try camera.startVideoSync(options: cameraOptions)
            }
        } catch {
            self.error = error
            
            if !isCancelled {
                cancel()
            }
        }
    }
    
    override public func cancel() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else {
            return
        }
        
        do {
            try camera.stopVideoSync()
        } catch let error {
            self.error = error
        }
    }
}
