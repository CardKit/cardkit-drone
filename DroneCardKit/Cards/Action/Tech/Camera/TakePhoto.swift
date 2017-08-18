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
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else { return }
        
        let hdr: Bool = self.optionalValue(forInput: "HDR") ?? false
        let aspect: DCKPhotoAspectRatio? = self.optionalValue(forInput: "AspectRatio")
        
        var cameraOptions: Set<CameraPhotoOption> = []
        if let aspect = aspect {
            cameraOptions.insert(.aspectRatio(aspect))
        }
        
        do {
            if !isCancelled {
                if hdr {
                    let photo: DCKPhoto = try camera.takeHDRPhoto(options: cameraOptions)
                    self.store(photo, forYieldIndex: 0)
                } else {
                    let photo: DCKPhoto = try camera.takePhoto(options: cameraOptions)
                    self.store(photo, forYieldIndex: 0)
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
