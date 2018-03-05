//
//  TakeTimelapse.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/24/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class TakeTimelapse: ExecutableAction {
    override public func main() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else { return }
        
        let aspect: DCKPhotoAspectRatio? = self.optionalValue(forInput: "AspectRatio")
        
        var cameraOptions: Set<CameraPhotoOption> = []
        if let aspect = aspect {
            cameraOptions.insert(.aspectRatio(aspect))
        }
        
        do {
            if !isCancelled {
                try camera.startTimelapse(options: cameraOptions)
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
            // stop the timelapse
            let video = try camera.stopTimelapse()
            
            // store the video as a yield
            self.store(video, forYieldIndex: 0)
            
        } catch let error {
            self.error(error)
        }
    }
}
