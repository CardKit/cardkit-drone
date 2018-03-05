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

// MARK: CameraToken

public protocol CameraToken {
    /// Take a single photo, with the given photo options specified.
    func takePhoto(options: Set<CameraPhotoOption>) throws -> DCKPhoto
    
    /// Take an HDR photo. Returns the image data.
    func takeHDRPhoto(options: Set<CameraPhotoOption>) throws -> DCKPhoto
    
    /// Take a burst of photos, with the given photo options specified. Returns the images
    /// produced in the photo burst.
    func takePhotoBurst(count: DCKPhotoBurstCount, options: Set<CameraPhotoOption>) throws -> DCKPhotoBurst
    
    /// Start taking photos with a given time interval.
    func startTakingPhotos(at interval: TimeInterval, options: Set<CameraPhotoOption>) throws
    
    /// Stop taking photos. Returns the photos that have been taken since `startTakingPhotos()` was
    /// called.
    func stopTakingPhotos() throws -> DCKPhotoBurst
    
    /// Start taking a timelapse movie.
    func startTimelapse(options: Set<CameraPhotoOption>) throws
    
    /// Stop taking a timelapse movie.
    func stopTimelapse() throws -> DCKVideo
    
    /// Start taking a video.
    func startVideo(options: Set<CameraVideoOption>) throws
    
    /// Stop taking a video.
    func stopVideo() throws -> DCKVideo
}

// MARK: - CameraPhotoOption

public enum CameraPhotoOption {
    case none
    case aspectRatio(DCKPhotoAspectRatio)
}

extension CameraPhotoOption: Equatable {
    public static func == (lhs: CameraPhotoOption, rhs: CameraPhotoOption) -> Bool {
        switch lhs {
        case .none:
            if case .none = rhs {
                return true
            } else {
                return false
            }
        case .aspectRatio(let lhs_ratio):
            if case .aspectRatio(let rhs_ratio) = rhs {
                return lhs_ratio == rhs_ratio
            } else {
                return false
            }
        }
    }
}

extension CameraPhotoOption: Hashable {
    public var hashValue: Int {
        switch self {
        case .none:
            return 0x00
        case .aspectRatio(let ratio):
            return 0x0F + ratio.hashValue
        }
    }
}

extension CameraPhotoOption: Codable {
    enum CodingError: Error {
        case unknownOption(String)
    }
    
    enum CodingKeys: String, CodingKey {
        case option
        case aspectRatio
        case quality
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let option = try values.decode(String.self, forKey: .option)
        switch option {
        case "none":
            self = .none
        case "aspectRatio":
            let aspectRatio = try values.decode(DCKPhotoAspectRatio.self, forKey: .aspectRatio)
            self = .aspectRatio(aspectRatio)
        default:
            throw CodingError.unknownOption(option)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .none:
            try container.encode("none", forKey: .option)
        case .aspectRatio(let ratio):
            try container.encode("aspectRatio", forKey: .option)
            try container.encode(ratio, forKey: .aspectRatio)
        }
    }
}

// MARK: - CameraVideoOption

public enum CameraVideoOption {
    case none
    case slowMotionEnabled
    case framerate(DCKVideoFramerate)
    case resolution(DCKVideoResolution)
}

extension CameraVideoOption: Equatable {
    public static func == (lhs: CameraVideoOption, rhs: CameraVideoOption) -> Bool {
        switch lhs {
        case .none:
            if case .none = rhs {
                return true
            } else {
                return false
            }
        case .slowMotionEnabled:
            if case .slowMotionEnabled = rhs {
                return true
            } else {
                return false
            }
        case .framerate(let lhs_fps):
            if case .framerate(let rhs_fps) = rhs {
                return lhs_fps == rhs_fps
            } else {
                return false
            }
        case .resolution(let lhs_resolution):
            if case .resolution(let rhs_resolution) = rhs {
                return lhs_resolution == rhs_resolution
            } else {
                return false
            }
        }
    }
}

extension CameraVideoOption: Hashable {
    public var hashValue: Int {
        switch self {
        case .none:
            return 0x000
        case .slowMotionEnabled:
            return 0x00F
        case .framerate(let fps):
            return 0x0F0 + fps.hashValue
        case .resolution(let resolution):
            return 0xF00 + resolution.hashValue
        }
    }
}

extension CameraVideoOption: Codable {
    enum CodingError: Error {
        case unknownOption(String)
    }
    
    enum CodingKeys: String, CodingKey {
        case option
        case framerate
        case resolution
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let option = try values.decode(String.self, forKey: .option)
        switch option {
        case "none":
            self = .none
        case "slowMotionEnabled":
            self = .slowMotionEnabled
        case "framerate":
            let framerate = try values.decode(DCKVideoFramerate.self, forKey: .framerate)
            self = .framerate(framerate)
        case "resolution":
            let resolution = try values.decode(DCKVideoResolution.self, forKey: .resolution)
            self = .resolution(resolution)
        default:
            throw CodingError.unknownOption(option)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .none:
            try container.encode("none", forKey: .option)
        case .slowMotionEnabled:
            try container.encode("slowMotionEnabled", forKey: .option)
        case .framerate(let fps):
            try container.encode("framerate", forKey: .option)
            try container.encode(fps, forKey: .framerate)
        case .resolution(let resolution):
            try container.encode("resolution", forKey: .option)
            try container.encode(resolution, forKey: .resolution)
        }
    }
}

// MARK: - CameraTokenError

public enum CameraTokenError: Error {
    case cameraAlreadyInUse
}
