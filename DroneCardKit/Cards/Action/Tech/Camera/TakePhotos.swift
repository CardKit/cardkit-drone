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
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken,
            let frequency: TimeInterval = self.value(forInput: "Frequency")
            else { return }
        
        let aspect: DCKPhotoAspectRatio? = self.optionalValue(forInput: "AspectRatio")
        
        var cameraOptions: Set<CameraPhotoOption> = []
        if let aspect = aspect {
            cameraOptions.insert(.aspectRatio(aspect))
        }
        
        do {
            if !isCancelled {
                try camera.startTakingPhotos(at: frequency, options: cameraOptions)
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
            self.store(photos, forYieldIndex: 0)
            
        } catch let error {
            self.error(error)
        }
    }
}
