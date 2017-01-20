//
//  CameraToken.swift
//  DroneCardKit
//
//  Created by Justin Manweiler on 12/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit
import CardKitRuntime

public typealias CameraTokenCompletionHandler = (Error?) -> Void

// MARK: CameraToken

public protocol CameraToken {
    /// Take a single photo, with the given photo options specified.
    func takePhoto(options: Set<CameraPhotoOption>, completionHandler: CameraTokenCompletionHandler?)
    
    /// Take a burst of photos, with the given photo options specified.
    func takePhotoBurst(count: PhotoBurstCount, options: Set<CameraPhotoOption>, completionHandler: CameraTokenCompletionHandler?)
    
    /// Start taking photos with a given time interval.
    func startTakingPhotos(at interval: TimeInterval, completionHandler: CameraTokenCompletionHandler?)
    
    /// Stop taking photos.
    func stopTakingPhotos(completionHandler: CameraTokenCompletionHandler?)
    
    /// Start taking a timelapse movie.
    func startTimelapse(completionHandler: CameraTokenCompletionHandler?)
    
    /// Stop taking a timelapse movie.
    func stopTimelapse(completionHandler: CameraTokenCompletionHandler?)
    
    /// Start taking a video.
    func startVideo(options: Set<CameraVideoOption>, completionHandler: CameraTokenCompletionHandler?)
    
    /// Stop taking a video.
    func stopVideo(completionHandler: CameraTokenCompletionHandler?)
}

// MARK: - Convienience -- take photo

public extension CameraToken {
    /// Take a single photo (16x9, Normal quality).
    final func takePhoto(completionHandler: CameraTokenCompletionHandler?) {
        let options: Set<CameraPhotoOption> = [.AspectRatio(.16x9), .PhotoQuality(.Normal)]
        self.takePhoto(options: defaults, completionHandler: completionHandler)
    }
}

// MARK: - Convienience -- take photo burst

public extension CameraToken {
    /// Take a burst of photos (16x9, Normal quality).
    final func takePhotoBurst(count: PhotoBurstCount, completionHandler: CameraTokenCompletionHandler?) {
        let options: Set<CameraPhotoOption> = [.AspectRatio(16x9), .PhotoQuality(.Normal)]
        self.takePhotoBurst(count: count, options: options, completionHandler: completionHandler)
    }
}

// MARK: - PhotoBurstCount

public enum PhotoBurstCount {
    case 3
    case 5
    case 7
    case 10
    case 14
}

// MARK: - CameraPhotoOption

public enum CameraPhotoOption {
    case AspectRatio(PhotoAspectRatio)
    case HDR
    case PhotoQuality(PhotoQuality)
}

public enum PhotoAspectRatio {
    case 4x3
    case 16x9
    case 3x2
}

public enum PhotoQuality {
    case Normal
    case Fine
    case Excellent
}

// MARK: - CameraVideoOption

public enum CameraVideoOption {
    case SlowMotionEnabled
    case VideoFramerate(VideoFramerate)
    case VideoResolution(VideoResolution)
}

public enum VideoResolution {
    case 720p
    case 1080p
    case 4k
}

public enum VideoFramerate {
    case 23_976fps
    case 24fps
    case 25fps
    case 29_970fps
    case 47_950fps
    case 59_940fps
    case 96fps
    case 120fps
}

// MARK: - CameraTokenError

public enum CameraTokenError: Error {
    case CameraAlreadyInUse
}
