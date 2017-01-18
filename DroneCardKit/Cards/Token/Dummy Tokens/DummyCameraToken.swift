//
//  DummyCameraToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 1/18/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKit
import CardKitRuntime

public class DummyCameraToken: ExecutableTokenCard, CameraToken {
    let prefix = ">> "
    let delay: TimeInterval = 3.0
    
    var isTakingPhotos = false
    var isTakingTimelapse = false
    
    func takePhoto(options: Set<CameraPhotoOption>, completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > takePhoto()")
        Thread.sleep(forTimeInterval: delay)
        completionHandler?(nil)
    }
    
    func takePhotoBurst(count: PhotoBurstCount, options: Set<CameraPhotoOption>, completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > takePhotoBurst(count: \(count), options: \(options))")
        Thread.sleep(forTimeInterval: delay)
        completionHandler?(nil)
    }
    
    func startTakingPhotos(at interval: TimeInterval, completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > startTakingPhotos(at: \(interval))")
        
        if self.isTakingPhotos || self.isTakingTimelapse {
            let error = CameraTokenError.CameraAlreadyInUse
            completionHandler?(error)
            return
        }
        
        self.isTakingPhotos = true
        completionHandler?(nil)
    }
    
    func stopTakingPhotos(completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > stopTakingPhotos()")
        self.isTakingPhotos = false
        completionHandler?(nil)
    }
    
    /// Start taking a timelapse movie.
    func startTimelapse(completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > startTimelapse()")
        
        if self.isTakingPhotos || self.isTakingTimelapse {
            let error = CameraTokenError.CameraAlreadyInUse
            completionHandler?(error)
            return
        }
        
        self.isTakingTimelapse = true
        completionHandler?(nil)
    }
    
    /// Stop taking a timelapse movie.
    func stopTimelapse(completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > stopTimelapse()")
        self.isTakingTimelapse = false
        completionHandler?(nil)
    }
}
