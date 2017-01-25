//
//  CameraToken.swift
//  DroneCardKit
//
//  Created by Justin Manweiler on 12/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

import CardKit
import CardKitRuntime

public typealias CameraTokenCompletionHandler = (Error?) -> Void

// MARK: CameraToken

public protocol CameraToken {
    /// Take a single photo, with the given photo options specified.
    func takePhoto(options: Set<CameraPhotoOption>, completionHandler: CameraTokenCompletionHandler?)
    
    /// Take an HDR photo
    func takeHDRPhoto(options: Set<CameraPhotoOption>, completionHandler: CameraTokenCompletionHandler?)
    
    /// Take a burst of photos, with the given photo options specified.
    func takePhotoBurst(count: PhotoBurstCount, options: Set<CameraPhotoOption>, completionHandler: CameraTokenCompletionHandler?)
    
    /// Start taking photos with a given time interval.
    func startTakingPhotos(at interval: TimeInterval, options: Set<CameraPhotoOption>, completionHandler: CameraTokenCompletionHandler?)
    
    /// Stop taking photos.
    func stopTakingPhotos(completionHandler: CameraTokenCompletionHandler?)
    
    /// Start taking a timelapse movie.
    func startTimelapse(options: Set<CameraPhotoOption>, completionHandler: CameraTokenCompletionHandler?)
    
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
        let options: Set<CameraPhotoOption> = [.AspectRatio(.Aspect_16x9), .Quality(.Normal)]
        self.takePhoto(options: options, completionHandler: completionHandler)
    }
}

// MARK: - Convienience -- take photo burst

public extension CameraToken {
    /// Take a burst of photos (16x9, Normal quality).
    final func takePhotoBurst(count: PhotoBurstCount, completionHandler: CameraTokenCompletionHandler?) {
        let options: Set<CameraPhotoOption> = [.AspectRatio(.Aspect_16x9), .Quality(.Normal)]
        self.takePhotoBurst(count: count, options: options, completionHandler: completionHandler)
    }
}

// MARK: - PhotoBurstCount

public enum PhotoBurstCount: String {
    case Burst_3
    case Burst_5
    case Burst_7
    case Burst_10
    case Burst_14
}

extension PhotoBurstCount: JSONEncodable, JSONDecodable {}

// MARK: - CameraPhotoOption

public enum CameraPhotoOption {
    case None
    case AspectRatio(PhotoAspectRatio)
    case Quality(PhotoQuality)
}

extension CameraPhotoOption: Equatable {
    public static func == (lhs: CameraPhotoOption, rhs: CameraPhotoOption) -> Bool {
        switch lhs {
        case .None:
            if case .None = rhs {
                return true
            } else {
                return false
            }
        case .AspectRatio(let lhs_ratio):
            if case .AspectRatio(let rhs_ratio) = rhs {
                return lhs_ratio == rhs_ratio
            } else {
                return false
            }
        case .Quality(let lhs_quality):
            if case .Quality(let rhs_quality) = rhs {
                return lhs_quality == rhs_quality
            } else {
                return false
            }
        }
    }
}

extension CameraPhotoOption: Hashable {
    public var hashValue: Int {
        switch self {
        case .None:
            return 0x00
        case .AspectRatio(let ratio):
            return 0x0F + ratio.hashValue
        case .Quality(let quality):
            return 0xF0 + quality.hashValue
        }
    }
}

extension CameraPhotoOption: JSONEncodable, JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.getString(at: "type")
        
        switch type {
        case "aspectRatio":
            do {
                let value = try json.getString(at: "value")
                if let ratio = PhotoAspectRatio(rawValue: value) {
                    self = .AspectRatio(ratio)
                } else {
                    self = .None
                }
            } catch {
                self = .None
            }
        case "quality":
            do {
                let value = try json.getString(at: "value")
                if let quality = PhotoQuality(rawValue: value) {
                    self = .Quality(quality)
                } else {
                    self = .None
                }
            } catch {
                self = .None
            }
        default:
            self = .None
        }
    }
    
    public func toJSON() -> JSON {
        switch self {
        case .None:
            return .dictionary([
                "type": "none"
            ])
        case .AspectRatio(let ratio):
            return .dictionary([
                "type": "aspectRatio",
                "value": ratio.toJSON()
                ])
        case .Quality(let quality):
            return .dictionary([
                "type": "quality",
                "value": quality.toJSON()
            ])
        }
    }
}

// MARK: PhotoAspectRatio

public enum PhotoAspectRatio: String {
    case Aspect_4x3
    case Aspect_16x9
    case Aspect_3x2
}

extension PhotoAspectRatio: JSONEncodable, JSONDecodable {}

// MARK: PhotoQuality

public enum PhotoQuality: String {
    case Normal
    case Fine
    case Excellent
}

extension PhotoQuality: JSONEncodable, JSONDecodable {}

// MARK: - CameraVideoOption

public enum CameraVideoOption {
    case None
    case SlowMotionEnabled
    case Framerate(VideoFramerate)
    case Resolution(VideoResolution)
}

extension CameraVideoOption: Equatable {
    public static func == (lhs: CameraVideoOption, rhs: CameraVideoOption) -> Bool {
        switch lhs {
        case .None:
            if case .None = rhs {
                return true
            } else {
                return false
            }
        case .SlowMotionEnabled:
            if case .SlowMotionEnabled = rhs {
                return true
            } else {
                return false
            }
        case .Framerate(let lhs_fps):
            if case .Framerate(let rhs_fps) = rhs {
                return lhs_fps == rhs_fps
            } else {
                return false
            }
        case .Resolution(let lhs_resolution):
            if case .Resolution(let rhs_resolution) = rhs {
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
        case .None:
            return 0x000
        case .SlowMotionEnabled:
            return 0x00F
        case .Framerate(let fps):
            return 0x0F0 + fps.hashValue
        case .Resolution(let resolution):
            return 0xF00 + resolution.hashValue
        }
    }
}

extension CameraVideoOption: JSONEncodable, JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.getString(at: "type")
        
        switch type {
        case "slowMotionEnabled":
            self = .SlowMotionEnabled
        case "framerate":
            do {
                let value = try json.getString(at: "value")
                if let fps = VideoFramerate(rawValue: value) {
                    self = .Framerate(fps)
                } else {
                    self = .None
                }
            } catch {
                self = .None
            }
        case "resolution":
            do {
                let value = try json.getString(at: "value")
                if let resolution = VideoResolution(rawValue: value) {
                    self = .Resolution(resolution)
                } else {
                    self = .None
                }
            } catch {
                self = .None
            }
        default:
            self = .None
        }
    }
    
    public func toJSON() -> JSON {
        switch self {
        case .None:
            return .dictionary([
                "type": "none"
                ])
        case .SlowMotionEnabled:
            return .dictionary([
                "type": "slowMotionEnabled"
                ])
        case .Framerate(let fps):
            return .dictionary([
                "type": "framerate",
                "value": fps.toJSON()
                ])
        case .Resolution(let resolution):
            return .dictionary([
                "type": "resolution",
                "value": resolution.toJSON()
                ])
        }
    }
}

public enum VideoResolution: String {
    case Resolution_720p
    case Resolution_1080p
    case Resolution_4k
}

extension VideoResolution: JSONEncodable, JSONDecodable {}

public enum VideoFramerate: String {
    case Framerate_23_976fps
    case Framerate_24fps
    case Framerate_25fps
    case Framerate_29_970fps
    case Framerate_47_950fps
    case Framerate_59_940fps
    case Framerate_96fps
    case Framerate_120fps
}

extension VideoFramerate: JSONEncodable, JSONDecodable {}

// MARK: - CameraTokenError

public enum CameraTokenError: Error {
    case CameraAlreadyInUse
}
