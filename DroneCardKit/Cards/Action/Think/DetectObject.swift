//
//  DetectObject.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 2/14/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class DetectObject: ExecutableActionCard {
    //swiftlint:ignore cyclomatic_complexity
    override public func main() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else {
            return
        }
        
        guard let telemetry: TelemetryToken = self.token(named: "Telemetry") as? TelemetryToken else {
            return
        }
        
        guard let watsonVisualRecognition: WatsonVisualRecognitionToken = self.token(named: "WatsonVisualRecognition") as? WatsonVisualRecognitionToken else {
            return
        }
        
        guard let objects: String = self.value(forInput: "Objects") else {
            return
        }
        
        let confidence: Double? = self.optionalValue(forInput: "Confidence")
        let frequency: Double? = self.optionalValue(forInput: "Frequency")
        
        // TODO this is hacky and will be removed
        guard let yield = self.yields.first else {
            self.error = ActionExecutionError.expectedYieldNotFound(self)
            return
        }
        
        // assuming Objects is a comma-separated string, chop it up
        let objectList = objects.components(separatedBy: ",")
        
        // we don't end until we've found the object we're looking for
        var foundObject: Bool = false
        
        repeat {
            // loop with the requested frequency -- if frequency is not set
            // then we will loop as fast as we can
            let loopStartDate: Date = Date()
            var nextLoopStartDate: Date = loopStartDate
            
            if let frequency = frequency {
                nextLoopStartDate.addTimeInterval(frequency)
            }
            
            do {
                // take a picture & classify
                let detectedObjects = try self.takePhotoAndClassify(camera: camera, telemetry: telemetry, watsonVisualRecognition: watsonVisualRecognition, confidence: confidence)
                
                // did we get what we were looking for?
                if !isCancelled {
                    for object in objectList {
                        for detectedObject in detectedObjects {
                            if object == detectedObject.objectName {
                                // yes!
                                foundObject = true
                                
                                // capture the detected object in our yields
                                // TODO this is hacky and will be fixed
                                self.yields[yield.key] = .bound(detectedObject.toJSON())
                                break
                            }
                        }
                    }
                }
                
            } catch {
                self.error = error
                
                if !isCancelled {
                    cancel()
                }
            }
            
            // sleep until next loop start date
            Thread.sleep(until: nextLoopStartDate)
        } while !foundObject
    }
    
    override public func cancel() {
        
    }
    
    fileprivate func takePhotoAndClassify(camera: CameraToken, telemetry: TelemetryToken, watsonVisualRecognition: WatsonVisualRecognitionToken, confidence: Double?) throws -> [DCKDetectedObject] {
        var photo: DCKPhoto?
        var detectedObjects: [DCKDetectedObject] = []
        
        // take a picture
        if !isCancelled {
            let options: Set<CameraPhotoOption> = [.aspectRatio(.aspect_16x9), .quality(.normal)]
            photo = try camera.takePhoto(options: options)
            
            // add drone's current location
            if let currentLocation = telemetry.currentLocation, let currentAltitude = telemetry.currentAltitude {
                photo?.location = DCKCoordinate3D(coordinate: currentLocation, altitude: currentAltitude)
            }
        }
        
        // save it to the Caches directory
        if !isCancelled {
            photo?.saveToCacheDirectory()
        }
        
        // send it to Watson
        if let photo = photo, let lfsPath = photo.pathInLocalFileSystem, !isCancelled {
            detectedObjects = try watsonVisualRecognition.classify(imageFile: lfsPath, threshold: confidence)
        }
        
        return detectedObjects
    }
}
