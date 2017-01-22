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
    
    public func takePhoto(options: Set<CameraPhotoOption>, completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > takePhoto()")
        Thread.sleep(forTimeInterval: delay)
        completionHandler?(nil)
    }
    
    public func takePhotoBurst(count: PhotoBurstCount, options: Set<CameraPhotoOption>, completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > takePhotoBurst(count: \(count), options: \(options))")
        Thread.sleep(forTimeInterval: delay)
        completionHandler?(nil)
    }
    
    public func startTakingPhotos(at interval: TimeInterval, completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > startTakingPhotos(at: \(interval))")
        
        if self.isTakingPhotos || self.isTakingTimelapse || self.isTakingVideo {
            let error = CameraTokenError.CameraAlreadyInUse
            completionHandler?(error)
            return
        }
        
        self.isTakingPhotos = true
        completionHandler?(nil)
    }
    
    public func stopTakingPhotos(completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > stopTakingPhotos()")
        self.isTakingPhotos = false
        completionHandler?(nil)
    }
    
    /// Start taking a timelapse movie.
    public func startTimelapse(completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > startTimelapse()")
        
        if self.isTakingPhotos || self.isTakingTimelapse || self.isTakingVideo {
            let error = CameraTokenError.CameraAlreadyInUse
            completionHandler?(error)
            return
        }
        
        self.isTakingTimelapse = true
        completionHandler?(nil)
    }
    
    /// Stop taking a timelapse movie.
    public func stopTimelapse(completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > stopTimelapse()")
        self.isTakingTimelapse = false
        completionHandler?(nil)
    }
    
    public func startVideo(options: Set<CameraVideoOption>, completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > startVideo(options: \(options))")
        
        if self.isTakingPhotos || self.isTakingTimelapse || self.isTakingVideo {
            let error = CameraTokenError.CameraAlreadyInUse
            completionHandler?(error)
            return
        }
        
        self.isTakingVideo = true
        completionHandler?(nil)
    }
    
    public func stopVideo(completionHandler: CameraTokenCompletionHandler?) {
        print("\(prefix) DummyCameraToken > stopVideo()")
        self.isTakingVideo = false
        completionHandler?(nil)
    }
}
