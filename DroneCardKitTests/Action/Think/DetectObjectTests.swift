//
//  DetectObjectTests.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 2/17/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest

import Freddy

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
        // executable card
        let detectObject = DetectObject(with: DroneCardKit.Action.Think.DetectObject.makeCard())
        
        // bind inputs & tokens
        let cameraToken = DummyCameraToken(with: DroneCardKit.Token.Camera.makeCard())
        let telemetryToken = DummyTelemetryToken(with: DroneCardKit.Token.Telemetry.makeCard())
        let watsonToken = WatsonVisualRecognitionToken(with: DroneCardKit.Token.Watson.VisualRecognition.makeCard(), usingApiKey: ApiKeys.justinsVisualRecoAPIKey)
        
        let inputBindings: [String : JSONEncodable] = ["Objects": "workroom", "Confidence": 0.7, "Frequency": 5.0]
        let tokenBindings = ["Camera": cameraToken, "Telemetry": telemetryToken, "WatsonVisualRecognition": watsonToken]
        
        detectObject.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "testDetectObject expectation")
        
        DispatchQueue.global(qos: .default).async {
            detectObject.main()
            myExpectation.fulfill()
        }
        
        // wait for execution to finish
        waitForExpectations(timeout: 5000) { error in
            if let error = error {
                XCTFail("testDetectObject error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(detectObject.errors.count == 0)
            detectObject.errors.forEach { XCTFail("\($0.localizedDescription)") }
            XCTAssertTrue(detectObject.yieldData.count > 0)
            
            guard let first = detectObject.yieldData.first else {
                XCTFail("expected a yield to be produced")
                return
            }
            
            do {
                let foundObject: DCKDetectedObject = try first.data.decode(type: DCKDetectedObject.self)
                XCTAssertEqual(foundObject.objectName, "workroom")
                XCTAssertTrue(foundObject.confidence > 0.7)
                
            } catch let error {
                XCTFail("expected a yield of type DCKDetectedObject, error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func testDetectObjectInDeck() {
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
            let objects = try CardKit.Input.Text.TextString <- "workroom"
            let confidence = try CardKit.Input.Numeric.Real <- 0.7
            let frequency = try CardKit.Input.Time.Periodicity <- 5.0
            
            detectObjects = try detectObjects <- ("Objects", objects)
            detectObjects = try detectObjects <- ("Confidence", confidence)
            detectObjects = try detectObjects <- ("Frequency", frequency)
        } catch let error {
            XCTFail("error binding inputs: \(error)")
        }
        
        // timer card
        var timer = CardKit.Action.Trigger.Time.Timer.makeCard()
        
        // bind inputs
        do {
            let duration = try CardKit.Input.Time.Duration <- 20.0
            timer = try timer <- ("Duration", duration)
        } catch let error {
            XCTFail("error binding inputs: \(error)")
        }
        
        // set up the deck -- one hand with detectObjects and a 20 second timer
        let deck = ( detectObjects || timer )%
//        let deck = ( ( detectObjects )% )%
        
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
            XCTAssertNil(error)
            
            XCTAssertTrue(yields.count == 1)
            
            var detectedObjects: [String : DCKDetectedObject] = [:]
            for yield in yields {
                do {
                    let object = try yield.data.decode(type: DCKDetectedObject.self)
                    detectedObjects[object.objectName] = object
                } catch let error {
                    XCTFail("expected a yield of type DCKDetectedObject, error: \(error.localizedDescription)")
                }
            }
            
            XCTAssertNotNil(detectedObjects["workroom"], "expected to find a workroom")
            XCTAssertTrue(detectedObjects["workroom"]!.confidence > 0.7)
        })
    }
}
