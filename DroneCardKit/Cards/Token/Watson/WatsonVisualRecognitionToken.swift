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
    
    init(with card: TokenCard, usingApiKey apiKey: String, version: String) {
        self.visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        
        super.init(with: card)
    }
    
    public func classify(imageFile: URL, threshold: Double?) throws -> DCKDetectedObject? {
        DispatchQueue.executeSynchronously {
            self.visualRecognition.classify(imageFile: imageFile, owners: ["IBM"], classifierIDs: nil, threshold: threshold, language: "en", failure: {
                error in
                throw error
            }, success: {
                (images: ClassifiedImages) in
                
                for image in images {
                    
                }
            })
        }
    }
}
