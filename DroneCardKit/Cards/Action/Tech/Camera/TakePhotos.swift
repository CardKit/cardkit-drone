//
//  TakePhotos.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/24/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class TakePhotos: ExecutableAction {
    override public func main() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else {
            return
        }
        
        guard let interval: TimeInterval = self.value(forInput: "Interval") else {
            return
        }
        
        let aspect: PhotoAspectRatio? = self.optionalValue(forInput: "AspectRatio")
        let quality: PhotoQuality? = self.optionalValue(forInput: "Quality")
        
        var cameraOptions: Set<CameraPhotoOption> = []
        if let aspect = aspect {
            cameraOptions.insert(.aspectRatio(aspect))
        }
        if let quality = quality {
            cameraOptions.insert(.quality(quality))
        }
        
        do {
            if !isCancelled {
                try camera.startTakingPhotos(at: interval, options: cameraOptions)
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
            // stop taking photos
            let photos = try camera.stopTakingPhotos()
            
            // store the photos as a yield
            self.store(data: photos, forYieldIndex: 0)
            
        } catch let error {
            self.error(error)
        }
    }
}
