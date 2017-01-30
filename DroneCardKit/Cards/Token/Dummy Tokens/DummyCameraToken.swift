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
    var isTakingVideo = false
    
    public func takePhoto(options: Set<CameraPhotoOption>, completionHandler: DroneTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > takePhoto(options: \(options))")
        Thread.sleep(forTimeInterval: delay)
        completionHandler?(nil)
    }
    
    public func takeHDRPhoto(options: Set<CameraPhotoOption>, completionHandler: DroneTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > takeHDRPhoto(options: \(options))")
        Thread.sleep(forTimeInterval: delay)
        completionHandler?(nil)
    }
    
    public func takePhotoBurst(count: PhotoBurstCount, options: Set<CameraPhotoOption>, completionHandler: DroneTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > takePhotoBurst(count: \(count), options: \(options))")
        Thread.sleep(forTimeInterval: delay)
        completionHandler?(nil)
    }
    
    public func startTakingPhotos(at interval: TimeInterval, options: Set<CameraPhotoOption>, completionHandler: DroneTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > startTakingPhotos(at: \(interval), options: \(options))")
        
        if self.isTakingPhotos || self.isTakingTimelapse || self.isTakingVideo {
            let error = CameraTokenError.cameraAlreadyInUse
            completionHandler?(error)
            return
        }
        
        self.isTakingPhotos = true
        completionHandler?(nil)
    }
    
    public func stopTakingPhotos(completionHandler: DroneTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > stopTakingPhotos()")
        self.isTakingPhotos = false
        completionHandler?(nil)
    }
    
    /// Start taking a timelapse movie.
    public func startTimelapse(options: Set<CameraPhotoOption>, completionHandler: DroneTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > startTimelapse(options: \(options))")
        
        if self.isTakingPhotos || self.isTakingTimelapse || self.isTakingVideo {
            let error = CameraTokenError.cameraAlreadyInUse
            completionHandler?(error)
            return
        }
        
        self.isTakingTimelapse = true
        completionHandler?(nil)
    }
    
    /// Stop taking a timelapse movie.
    public func stopTimelapse(completionHandler: DroneTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > stopTimelapse()")
        self.isTakingTimelapse = false
        completionHandler?(nil)
    }
    
    public func startVideo(options: Set<CameraVideoOption>, completionHandler: DroneTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > startVideo(options: \(options))")
        
        if self.isTakingPhotos || self.isTakingTimelapse || self.isTakingVideo {
            let error = CameraTokenError.cameraAlreadyInUse
            completionHandler?(error)
            return
        }
        
        self.isTakingVideo = true
        completionHandler?(nil)
    }
    
    public func stopVideo(completionHandler: DroneTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > stopVideo()")
        self.isTakingVideo = false
        completionHandler?(nil)
    }
}
