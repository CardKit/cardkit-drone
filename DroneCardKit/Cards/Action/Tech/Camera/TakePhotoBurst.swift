//
//  TakePhotoBurst.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/24/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class TakePhotoBurst: ExecutableAction {
    override public func main() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken,
            let burstCount: DCKPhotoBurstCount = self.value(forInput: "BurstCount")
            else { return }
        
        let aspect: DCKPhotoAspectRatio? = self.optionalValue(forInput: "AspectRatio")
        
        var cameraOptions: Set<CameraPhotoOption> = []
        if let aspect = aspect {
            cameraOptions.insert(.aspectRatio(aspect))
        }
        
        do {
            if !isCancelled {
                let burst = try camera.takePhotoBurst(count: burstCount, options: cameraOptions)
                self.store(burst, forYieldIndex: 0)
            }
        } catch {
            self.error(error)
            
            if !isCancelled {
                cancel()
            }
        }
    }
    
    override public func cancel() {
        // TakePhotoBurst is an atomic operation;
        // either it's taken or it's not taken
    }
}
