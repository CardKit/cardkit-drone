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
    let justinsVisualRecoAPIKey = "f9551503df1b354ffd6e8543b2470c377d3c29a9"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWatsonVisualRecognition() {
        let watsonCard = DroneCardKit.Token.Watson.VisualRecognition.makeCard()
        let watsonToken = WatsonVisualRecognitionToken(with: watsonCard, usingApiKey: justinsVisualRecoAPIKey)
        
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
        let watsonToken = WatsonVisualRecognitionToken(with: watsonCard, usingApiKey: justinsVisualRecoAPIKey)
        
        let myBundle = Bundle(for: type(of: self))
        guard let image: UIImage = UIImage(named: "dolomites.jpg", in: myBundle, compatibleWith: nil) else {
            XCTFail("could not find path of dolomites.jpg in testbundle")
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
}
