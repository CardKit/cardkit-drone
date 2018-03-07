/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

import CardKit
import CardKitRuntime

public class MockCameraToken: BaseMockToken, CameraToken {
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
        self.registerFunctionCall(named: "takePhoto")
        print("\(prefix) MockCameraToken > takePhoto(options: \(options))")
        
        Thread.sleep(forTimeInterval: delay)
        
        return self.makePhoto()
    }
    
    public func takeHDRPhoto(options: Set<CameraPhotoOption>) throws -> DCKPhoto {
        self.registerFunctionCall(named: "takeHDRPhoto")
        print("\(prefix) MockCameraToken > takeHDRPhoto(options: \(options))")
        
        Thread.sleep(forTimeInterval: delay)
        
        return self.makePhoto()
    }
    
    public func takePhotoBurst(count: DCKPhotoBurstCount, options: Set<CameraPhotoOption>) throws -> DCKPhotoBurst {
        self.registerFunctionCall(named: "takePhotoBurst")
        print("\(prefix) MockCameraToken > takePhotoBurst(count: \(count), options: \(options))")
        
        Thread.sleep(forTimeInterval: delay)
        
        return DCKPhotoBurst(photos: [self.makePhoto(), self.makePhoto(), self.makePhoto()])
    }
    
    public func startTakingPhotos(at interval: TimeInterval, options: Set<CameraPhotoOption>) throws {
        self.registerFunctionCall(named: "startTakingPhotos")
        print("\(prefix) MockCameraToken > startTakingPhotos(at: \(interval), options: \(options))")
        
        if self.isTakingPhotos || self.isTakingTimelapse || self.isTakingVideo {
            throw CameraTokenError.cameraAlreadyInUse
        }
        
        self.isTakingPhotos = true
    }
    
    public func stopTakingPhotos() throws -> DCKPhotoBurst {
        self.registerFunctionCall(named: "stopTakingPhotos")
        print("\(prefix) MockCameraToken > stopTakingPhotos()")
        
        self.isTakingPhotos = false
        
        return DCKPhotoBurst(photos: [self.makePhoto(), self.makePhoto(), self.makePhoto()])
    }
    
    public func startTimelapse(options: Set<CameraPhotoOption>) throws {
        self.registerFunctionCall(named: "startTimelapse")
        print("\(prefix) MockCameraToken > startTimelapse(options: \(options))")
        
        if self.isTakingPhotos || self.isTakingTimelapse || self.isTakingVideo {
            throw CameraTokenError.cameraAlreadyInUse
        }
        
        self.isTakingTimelapse = true
    }
    
    public func stopTimelapse() throws -> DCKVideo {
        self.registerFunctionCall(named: "stopTimelapse")
        print("\(prefix) MockCameraToken > stopTimelapse()")
        
        self.isTakingTimelapse = false
        
        return self.makeVideo()
    }
    
    public func startVideo(options: Set<CameraVideoOption>) throws {
        self.registerFunctionCall(named: "startVideo")
        print("\(prefix) MockCameraToken > startVideo(options: \(options))")
        
        if self.isTakingPhotos || self.isTakingTimelapse || self.isTakingVideo {
            throw CameraTokenError.cameraAlreadyInUse
        }
        
        self.isTakingVideo = true
    }
    
    public func stopVideo() throws -> DCKVideo {
        self.registerFunctionCall(named: "stopVideo")
        print("\(prefix) MockCameraToken > stopVideo()")
        
        self.isTakingVideo = false
        
        return self.makeVideo()
    }
}
