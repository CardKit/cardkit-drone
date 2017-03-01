//
//  WatsonVisualRecognitionTokenTests.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 2/28/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest

@testable import CardKit
@testable import CardKitRuntime
@testable import DroneCardKit

class WatsonVisualRecognitionTokenTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWatsonVisualRecognitionWithFile() {
        let watsonCard = DroneCardKit.Token.Watson.VisualRecognition.makeCard()
        let watsonToken = WatsonVisualRecognitionToken(with: watsonCard, usingApiKey: ApiKeys.justinsVisualRecoAPIKey)
        
        let myBundle = Bundle(for: type(of: self))
        guard let imagePath = myBundle.path(forResource: "lab", ofType: "jpg") else {
            XCTFail("could not find path of lab.jpg in test bundle")
            return
        }
        
        do {
            let detectedObjects = try watsonToken.classify(imagePath: imagePath, threshold: 0.3)
            
            /* this is what we expect to get back:
             [DroneCardKit.DCKDetectedObject(objectName: "workroom", confidence: 0.78600000000000003), 
             DroneCardKit.DCKDetectedObject(objectName: "room", confidence: 0.878),
             DroneCardKit.DCKDetectedObject(objectName: "study hall", confidence: 0.56799999999999995),
             DroneCardKit.DCKDetectedObject(objectName: "cubicle", confidence: 0.56200000000000006),
             DroneCardKit.DCKDetectedObject(objectName: "enclosure", confidence: 0.56200000000000006),
             DroneCardKit.DCKDetectedObject(objectName: "classroom", confidence: 0.55400000000000005),
             DroneCardKit.DCKDetectedObject(objectName: "ultramarine color", confidence: 0.89700000000000002),
             DroneCardKit.DCKDetectedObject(objectName: "blue color", confidence: 0.76900000000000002)]
             */
            var results: [String : DCKDetectedObject] = [:]
            for result in detectedObjects {
                results[result.objectName] = result
            }
            
            // start asserting!
            XCTAssertNotNil(results["workroom"])
            XCTAssert(results["workroom"]!.confidence > 0.7)
            XCTAssertNotNil(results["room"])
            XCTAssert(results["room"]!.confidence > 0.8)
            XCTAssertNotNil(results["study hall"])
            XCTAssert(results["study hall"]!.confidence > 0.5)
            XCTAssertNotNil(results["cubicle"])
            XCTAssert(results["cubicle"]!.confidence > 0.5)
            XCTAssertNotNil(results["enclosure"])
            XCTAssert(results["enclosure"]!.confidence > 0.5)
            XCTAssertNotNil(results["classroom"])
            XCTAssert(results["classroom"]!.confidence > 0.5)
            XCTAssertNotNil(results["ultramarine color"])
            XCTAssert(results["ultramarine color"]!.confidence > 0.8)
            XCTAssertNotNil(results["blue color"])
            XCTAssert(results["blue color"]!.confidence > 0.7)
            
        } catch let error {
            XCTFail("error: \(error.localizedDescription)")
        }
    }
    
    func testWatsonVisualRecognitionWithUIImage() {
        let watsonCard = DroneCardKit.Token.Watson.VisualRecognition.makeCard()
        let watsonToken = WatsonVisualRecognitionToken(with: watsonCard, usingApiKey: ApiKeys.justinsVisualRecoAPIKey)
        
        let myBundle = Bundle(for: type(of: self))
        guard let image: UIImage = UIImage(named: "dolomites.jpg", in: myBundle, compatibleWith: nil) else {
            XCTFail("could not find path of dolomites.jpg in testbundle")
            return
        }
        
        do {
            let detectedObjects = try watsonToken.classify(image: image, threshold: 0.3)
            
            /* this is what we expect to get back:
             [DroneCardKit.DCKDetectedObject(objectName: "mountain range", confidence: 0.78300000000000003),
             DroneCardKit.DCKDetectedObject(objectName: "nature", confidence: 0.89300000000000002),
             DroneCardKit.DCKDetectedObject(objectName: "extremum (peak)", confidence: 0.67500000000000004),
             DroneCardKit.DCKDetectedObject(objectName: "ridge", confidence: 0.61899999999999999),
             DroneCardKit.DCKDetectedObject(objectName: "tableland (plateau)", confidence: 0.55400000000000005),
             DroneCardKit.DCKDetectedObject(objectName: "highland", confidence: 0.58199999999999996),
             DroneCardKit.DCKDetectedObject(objectName: "blue color", confidence: 0.86899999999999999),
             DroneCardKit.DCKDetectedObject(objectName: "yellow color", confidence: 0.77700000000000002)]
             */
            var results: [String : DCKDetectedObject] = [:]
            for result in detectedObjects {
                results[result.objectName] = result
            }
            
            // start asserting!
            XCTAssertNotNil(results["mountain range"])
            XCTAssert(results["mountain range"]!.confidence > 0.7)
            XCTAssertNotNil(results["nature"])
            XCTAssert(results["nature"]!.confidence > 0.8)
            XCTAssertNotNil(results["extremum (peak)"])
            XCTAssert(results["extremum (peak)"]!.confidence > 0.6)
            XCTAssertNotNil(results["ridge"])
            XCTAssert(results["ridge"]!.confidence > 0.6)
            XCTAssertNotNil(results["tableland (plateau)"])
            XCTAssert(results["tableland (plateau)"]!.confidence > 0.5)
            XCTAssertNotNil(results["highland"])
            XCTAssert(results["highland"]!.confidence > 0.5)
            XCTAssertNotNil(results["blue color"])
            XCTAssert(results["blue color"]!.confidence > 0.8)
            XCTAssertNotNil(results["yellow color"])
            XCTAssert(results["yellow color"]!.confidence > 0.7)
            
        } catch let error {
            XCTFail("error: \(error.localizedDescription)")
        }
    }
    
    func testWatsonVisualRecognitionSpeed() {
        let watsonCard = DroneCardKit.Token.Watson.VisualRecognition.makeCard()
        let watsonToken = WatsonVisualRecognitionToken(with: watsonCard, usingApiKey: ApiKeys.justinsVisualRecoAPIKey)
        
        let myBundle = Bundle(for: type(of: self))
        guard let image: UIImage = UIImage(named: "dolomites.jpg", in: myBundle, compatibleWith: nil) else {
            XCTFail("could not find path of dolomites.jpg in test bundle")
            return
        }
        
        measure {
            do {
                let _ = try watsonToken.classify(image: image, threshold: 0.3)
            } catch let error {
                XCTFail("error: \(error.localizedDescription)")
            }
        }
    }
    
    func testWatsonVisualRecognitionForError() {
        let watsonCard = DroneCardKit.Token.Watson.VisualRecognition.makeCard()
        let watsonToken = WatsonVisualRecognitionToken(with: watsonCard, usingApiKey: ApiKeys.justinsVisualRecoAPIKey)
        
        let myBundle = Bundle(for: type(of: self))
        guard let imagePath = myBundle.path(forResource: "dolomites", ofType: "jpg") else {
            XCTFail("could not find path of dolomites.jpg in test bundle")
            return
        }
        
        do {
            let _ = try watsonToken.classify(imagePath: imagePath, threshold: 0.3)
            XCTFail("expected Watson Visual Recognition to return an error (image size > 2mb)")
            
        } catch let error {
            XCTAssertTrue(error.localizedDescription == "Image size limit exceeded (2446517 bytes > 2097152 bytes [2 MiB]). -- Images Processed: 1")
        }
    }
}
