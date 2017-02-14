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
    override public func main() {
        guard let camera: CameraToken = self.token(named: "Camera") as? CameraToken else {
            return
        }
        
        guard let droneTelemetry: DroneTelemetryToken = self.token(named: "DroneTelemetry") as? DroneTelemetryToken else {
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
        
        var detectedObjects: [DCKDetectedObject] = []
        
        // TODO loop with frequency
        do {
            // take a picture
            if !isCancelled {
                camera.takePhoto(options: <#T##Set<CameraPhotoOption>#>)
            }
            
            // send it to watson
            if !isCancelled {
                detectedObjects = watsonVisualRecognition.classify(imageFile: <#T##URL#>, threshold: confidence)
            }
            
            // did we get what we were looking for?
            if !isCancelled {
                for object in objectList {
                    for detectedObject in detectedObjects {
                        if object == detectedObject.objectName {
                            // yes!
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
    }
    
    override public func cancel() {
        
    }
}
