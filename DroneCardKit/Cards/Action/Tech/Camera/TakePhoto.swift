//
//  TakePhoto.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/23/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class TakePhoto: ExecutableAction {
    override public func main() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else {
            return
        }
        
        let hdr: Bool = self.optionalValue(forInput: "HDR") ?? false
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
                if hdr {
                    let photo = try camera.takeHDRPhoto(options: cameraOptions)
                    self.store(data: photo, forYieldIndex: 0)
                } else {
                    let photo = try camera.takePhoto(options: cameraOptions)
                    self.store(data: photo, forYieldIndex: 0)
                }
            }
        } catch let error {
            self.error(error)
            
            if !isCancelled {
                cancel()
            }
        }
    }
    
    override public func cancel() {
        // TakePhoto seems to be an atomic operation;
        // either it's taken or it's not taken
    }
}
