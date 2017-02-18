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
    
    var photoCount = 0
    
    fileprivate func makePhoto() -> DCKPhoto {
        let photoCounter = "".appendingFormat("%03d", self.photoCount)
        let fileName = "DUMMY_\(photoCounter).JPG"
        
        let photo = DCKPhoto(fileName: fileName, sizeInBytes: 100, timeCreated: Date(), data: Data(), location: nil)
        return photo
    }
    
    fileprivate func makeVideo() -> DCKVideo {
        let photoCounter = "".appendingFormat("%03d", self.photoCount)
        let fileName = "DUMMY_\(photoCounter).M4V"
        
        let video = DCKVideo(fileName: fileName, sizeInBytes: 1000, timeCreated: Date(), durationInSeconds: 60, data: Data())
        return video
    }
    
    public func takePhoto(options: Set<CameraPhotoOption>) throws -> DCKPhoto {
        print("\(prefix) DummyCameraToken > takePhoto(options: \(options))")
        Thread.sleep(forTimeInterval: delay)
        
        return self.makePhoto()
    }
    
    public func takeHDRPhoto(options: Set<CameraPhotoOption>) throws -> DCKPhoto {
        print("\(prefix) DummyCameraToken > takeHDRPhoto(options: \(options))")
        Thread.sleep(forTimeInterval: delay)
        
        return self.makePhoto()
    }
    
    public func takePhotoBurst(count: PhotoBurstCount, options: Set<CameraPhotoOption>) throws -> DCKPhotoBurst {
        print("\(prefix) DummyCameraToken > takePhotoBurst(count: \(count), options: \(options))")
        Thread.sleep(forTimeInterval: delay)
        
        return DCKPhotoBurst(photos: [self.makePhoto(), self.makePhoto(), self.makePhoto()])
    }
    
    public func startTakingPhotos(at interval: TimeInterval, options: Set<CameraPhotoOption>) throws {
        print("\(prefix) DummyCameraToken > startTakingPhotos(at: \(interval), options: \(options))")
        
        if self.isTakingPhotos || self.isTakingTimelapse || self.isTakingVideo {
            throw CameraTokenError.cameraAlreadyInUse
        }
        
        self.isTakingPhotos = true
    }
    
    public func stopTakingPhotos() throws -> DCKPhotoBurst {
        print("\(prefix) DummyCameraToken > stopTakingPhotos()")
        self.isTakingPhotos = false
        
        return DCKPhotoBurst(photos: [self.makePhoto(), self.makePhoto(), self.makePhoto()])
    }
    
    public func startTimelapse(options: Set<CameraPhotoOption>) throws {
        print("\(prefix) DummyCameraToken > startTimelapse(options: \(options))")
        
        if self.isTakingPhotos || self.isTakingTimelapse || self.isTakingVideo {
            throw CameraTokenError.cameraAlreadyInUse
        }
        
        self.isTakingTimelapse = true
    }
    
    public func stopTimelapse() throws -> DCKVideo {
        print("\(prefix) DummyCameraToken > stopTimelapse()")
        self.isTakingTimelapse = false
        
        return self.makeVideo()
    }
    
    public func startVideo(options: Set<CameraVideoOption>) throws {
        print("\(prefix) DummyCameraToken > startVideo(options: \(options))")
        
        if self.isTakingPhotos || self.isTakingTimelapse || self.isTakingVideo {
            throw CameraTokenError.cameraAlreadyInUse
        }
        
        self.isTakingVideo = true
    }
    
    public func stopVideo() throws -> DCKVideo {
        print("\(prefix) DummyCameraToken > stopVideo()")
        self.isTakingVideo = false
        
        return self.makeVideo()
    }
}
