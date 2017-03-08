//
//  RecordVideo.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/19/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class RecordVideo: ExecutableAction {
    override public func main() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else {
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
                try camera.startVideo(options: cameraOptions)
            }
        } catch let error {
            self.error(error)
            
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
            // stop recording the video
            let video = try camera.stopVideo()
            
            // save it as a yield
            self.store(data: video, forYieldIndex: 0)
            
        } catch let error {
            self.error(error)
        }
    }
}
