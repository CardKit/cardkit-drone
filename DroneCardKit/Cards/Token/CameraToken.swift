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
    case quality(DCKPhotoQuality)
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
        case .quality(let lhs_quality):
            if case .quality(let rhs_quality) = rhs {
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
        case .none:
            return 0x00
        case .aspectRatio(let ratio):
            return 0x0F + ratio.hashValue
        case .quality(let quality):
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
                if let ratio = DCKPhotoAspectRatio(rawValue: value) {
                    self = .aspectRatio(ratio)
                } else {
                    self = .none
                }
            } catch {
                self = .none
            }
        case "quality":
            do {
                let value = try json.getString(at: "value")
                if let quality = DCKPhotoQuality(rawValue: value) {
                    self = .quality(quality)
                } else {
                    self = .none
                }
            } catch {
                self = .none
            }
        default:
            self = .none
        }
    }
    
    public func toJSON() -> JSON {
        switch self {
        case .none:
            return .dictionary([
                "type": "none"
            ])
        case .aspectRatio(let ratio):
            return .dictionary([
                "type": "aspectRatio",
                "value": ratio.toJSON()
                ])
        case .quality(let quality):
            return .dictionary([
                "type": "quality",
                "value": quality.toJSON()
            ])
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

extension CameraVideoOption: JSONEncodable, JSONDecodable {
    public init(json: JSON) throws {
        let type = try json.getString(at: "type")
        
        switch type {
        case "slowMotionEnabled":
            self = .slowMotionEnabled
        case "framerate":
            do {
                let value = try json.getString(at: "value")
                if let fps = DCKVideoFramerate(rawValue: value) {
                    self = .framerate(fps)
                } else {
                    self = .none
                }
            } catch {
                self = .none
            }
        case "resolution":
            do {
                let value = try json.getString(at: "value")
                if let resolution = DCKVideoResolution(rawValue: value) {
                    self = .resolution(resolution)
                } else {
                    self = .none
                }
            } catch {
                self = .none
            }
        default:
            self = .none
        }
    }
    
    public func toJSON() -> JSON {
        switch self {
        case .none:
            return .dictionary([
                "type": "none"
                ])
        case .slowMotionEnabled:
            return .dictionary([
                "type": "slowMotionEnabled"
                ])
        case .framerate(let fps):
            return .dictionary([
                "type": "framerate",
                "value": fps.toJSON()
                ])
        case .resolution(let resolution):
            return .dictionary([
                "type": "resolution",
                "value": resolution.toJSON()
                ])
        }
    }
}

// MARK: - CameraTokenError

public enum CameraTokenError: Error {
    case cameraAlreadyInUse
}
