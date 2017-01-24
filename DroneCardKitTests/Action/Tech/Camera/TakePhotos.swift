//
//  TakePhotos.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/24/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class TakePhotos: ExecutableActionCard {
    override public func main() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        guard let interval: TimeInterval = self.value(forInput: "Interval") else {
            self.error = DroneTokenError.MandatoryInputAquisitionFailed
            return
        }
        
        let aspect: PhotoAspectRatio? = self.optionalValue(forInput: "AspectRatio")
        let hdr: Bool? = self.optionalValue(forInput: "HDR")
        let quality: PhotoQuality? = self.optionalValue(forInput: "Quality")
        
        var cameraOptions: Set<CameraPhotoOption> = []
        if let aspect = aspect {
            cameraOptions.insert(.AspectRatio(aspect))
        }
        if let _ = hdr {
            cameraOptions.insert(.HDR)
        }
        if let quality = quality {
            cameraOptions.insert(.Quality(quality))
        }
        
        if !isCancelled {
            camera.startTakingPhotos(at: interval, completionHandler: {
                error in
                self.error = error
            })
        }
    }
    
    override public func cancel() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        camera.stopTakingPhotos(completionHandler: {
            error in
            self.error = error
        })
    }
}
