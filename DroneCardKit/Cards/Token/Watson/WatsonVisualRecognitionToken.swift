//
//  WatsonVisualRecognitionToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 2/14/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import Freddy
import RestKit
import VisualRecognitionV3

import CardKit
import CardKitRuntime

// MARK: WatsonVisualRecognitionToken

public class WatsonVisualRecognitionToken: ExecutableTokenCard {
    private let visualRecognition: VisualRecognition
    
    init(with card: TokenCard, usingApiKey apiKey: String, version: String? = nil) {
        
        // latest version specified here:
        // https://www.ibm.com/watson/developercloud/visual-recognition/api/v3/#classify_an_image
        var requestedVersion = "2016-05-20"
        
        if let version = version {
            requestedVersion = version
        }
        
        self.visualRecognition = VisualRecognition(apiKey: apiKey, version: requestedVersion)
        
        super.init(with: card)
    }
    
    public func classify(imageFile: URL, threshold: Double?) throws -> [DCKDetectedObject] {
        var detectedObjects: [DCKDetectedObject] = []
        
        try DispatchQueue.executeSynchronously { asyncCompletionHandler in
            self.visualRecognition.classify(imageFile: imageFile, owners: ["IBM"], classifierIDs: nil, threshold: threshold, language: "en", failure: { error in
                asyncCompletionHandler?(error)
            }, success: { (classifiedImages: ClassifiedImages) in
                
                for image in classifiedImages.images {
                    for classifier in image.classifiers {
                        for cls in classifier.classes {
                            let object = DCKDetectedObject(objectName: cls.classification, confidence: cls.score)
                            detectedObjects.append(object)
                        }
                    }
                }
                
                asyncCompletionHandler?(nil)
            })
        }
        
        return detectedObjects
    }
}
