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

import CardKitRuntime

public class RecordVideo: ExecutableAction {
    override public func main() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else { return }
        
        let framerate: DCKVideoFramerate? = self.optionalValue(forInput: "Framerate")
        let resolution: DCKVideoResolution? = self.optionalValue(forInput: "Resolution")
        let slowmo: Bool? = self.optionalValue(forInput: "SlowMotionEnabled")
        
        var cameraOptions: Set<CameraVideoOption> = []
        if let framerate = framerate {
            cameraOptions.insert(.framerate(framerate))
        }
        if let resolution = resolution {
            cameraOptions.insert(.resolution(resolution))
        }
        if slowmo != nil {
            cameraOptions.insert(.slowMotionEnabled)
        }
        
        do {
            if !isCancelled {
                try camera.startVideo(options: cameraOptions)
            }
        } catch let error {
            self.error(error)
            
            if !isCancelled {
                cancel()
            }
        }
    }
    
    override public func cancel() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else {
            return
        }
        
        do {
            // stop recording the video
            let video = try camera.stopVideo()
            
            // save it as a yield
            self.store(video, forYieldIndex: 0)
            
        } catch let error {
            self.error(error)
        }
    }
}
