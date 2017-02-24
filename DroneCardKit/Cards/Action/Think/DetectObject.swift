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
                            if object.lowercased() == detectedObject.objectName.lowercased() {
                                // yes!
                                foundObject = true
                                
                                // capture the detected object in our yields
                                self.store(data: detectedObject, forYieldIndex: 0)
                                break
                            }
                        }
                    }
                }
                
            } catch {
                self.error(error)
                
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
        
        // send it to Watson
        if let photo = photo, let lfsPath = photo.pathInLocalFileSystem, !isCancelled {
            detectedObjects = try watsonVisualRecognition.classify(imageFile: lfsPath, threshold: confidence)
        }
        
        return detectedObjects
    }
}

// MARK: - TimeoutQueue

fileprivate class LimitedLifetimeQueue<T> {
    private var array: [T] = []
    private let accessQueue = DispatchQueue(label: "LimitedLifetimeQueueAccess", attributes: .concurrent)
    
    public var count: Int {
        var count = 0
        
        self.accessQueue.sync {
            count = self.array.count
        }
        
        return count
    }
    
    public func enqueue(newElement: T, withLifetime lifetime: TimeInterval) {
        self.accessQueue.async(flags: .barrier) {
            self.array.append(newElement)
        }
    }
    
    public func dequeue() -> T? {
        var element: T?
        
        self.accessQueue.async(flags: .barrier) {
            element = self.array.remove(at: 0)
        }
        
        return element
    }
}
