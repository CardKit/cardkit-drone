//
//  DetectObjectTests.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 2/17/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest

@testable import CardKit
@testable import CardKitRuntime
@testable import DroneCardKit

class DetectObjectTests: XCTestCase {
    
    // this is justin's API key
    private let watsonVisualRecognitionAPIKey = "f9551503df1b354ffd6e8543b2470c377d3c29a9"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDetectObject() {
        // token cards
        let cameraCard = DroneCardKit.Token.Camera.makeCard()
        let telemetryCard = DroneCardKit.Token.Telemetry.makeCard()
        let watsonCard = DroneCardKit.Token.Watson.VisualRecognition.makeCard()
        
        // detectObjects card
        var detectObjects = DroneCardKit.Action.Think.DetectObject.makeCard()
        
        // bind tokens
        do {
            detectObjects = try detectObjects <- ("Camera", cameraCard)
            detectObjects = try detectObjects <- ("Telemetry", telemetryCard)
            detectObjects = try detectObjects <- ("WatsonVisualRecognition", watsonCard)
        } catch let error {
            XCTFail("error binding token cards: \(error)")
        }
        
        // bind inputs
        do {
            let objects = try CardKit.Input.Text.TextString <- "person"
            let confidence = try CardKit.Input.Numeric.Real <- 0.7
            let frequency = try CardKit.Input.Numeric.Real <- 2.0
            
            detectObjects = try detectObjects <- ("Objects", objects)
            detectObjects = try detectObjects <- ("Confidence", confidence)
            detectObjects = try detectObjects <- ("Frequency", frequency)
        } catch let error {
            XCTFail("error binding inputs: \(error)")
        }
        
        // set up the deck -- one hand with detectObjects
        let deck = ( ( detectObjects )% )%
        
        // add tokens to the deck
        deck.add(cameraCard)
        deck.add(telemetryCard)
        deck.add(watsonCard)
        
        // set up the execution engine
        let engine = ExecutionEngine(with: deck)
        engine.setExecutableActionType(DetectObject.self, for: DroneCardKit.Action.Think.DetectObject)
        
        // create token instances
        let camera = DummyCameraToken(with: cameraCard)
        let telemetry = DummyTelemetryToken(with: telemetryCard)
        let watson = WatsonVisualRecognitionToken(with: watsonCard, usingApiKey: watsonVisualRecognitionAPIKey)
        
        engine.setTokenInstance(camera, for: cameraCard)
        engine.setTokenInstance(telemetry, for: telemetryCard)
        engine.setTokenInstance(watson, for: watsonCard)
        
        // execute
        engine.execute({ (yields: [YieldData], error: ExecutionError?) in
            for yield in yields {
                print("yield: \(yield.data)")
            }
            XCTAssertNil(error)
        })
    }
}
