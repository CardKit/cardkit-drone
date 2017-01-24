//
//  TakePhotoBurst.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/24/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class TakePhotoBurst: ExecutableActionCard {
    override public func main() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        guard let burstCount: PhotoBurstCount = self.value(forInput: "BurstCount") else {
            error = DroneTokenError.MandatoryInputAquisitionFailed
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
            camera.takePhotoBurst(count: burstCount, options: cameraOptions, completionHandler: {
                error in
                self.error = error
            })
        }
    }
    
    override public func cancel() {
        // TakePhotoBurst seems to be an atomic operation;
        // either it's taken or it's not taken
    }
}
