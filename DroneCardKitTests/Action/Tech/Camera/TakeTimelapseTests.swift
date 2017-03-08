//
//  TakeTimelapseTests.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 3/2/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest

import Freddy

@testable import CardKit
@testable import CardKitRuntime
@testable import DroneCardKit

class TakeTimelapseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTakeTimelapse() {
        // executable card
        let takeTimelapse = TakeTimelapse(with: DroneCardKit.Action.Tech.Camera.TakeTimelapse.makeCard())
        
        // bind inputs and tokens
        let cameraToken = DummyCameraToken(with: DroneCardKit.Token.Camera.makeCard())
        let aspectRatio = DCKPhotoAspectRatio.aspect_16x9
        let quality = DCKPhotoQuality.excellent
        let inputBindings: [String : JSONEncodable] = ["AspectRatio": aspectRatio, "Quality": quality]
        let tokenBindings = ["Camera": cameraToken]
        
        takeTimelapse.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        DispatchQueue.global(qos: .default).async {
            takeTimelapse.main()
        }
        
        // give the card some time to process
        Thread.sleep(forTimeInterval: DroneCardKitTests.nonEndingCardProcessTime)
        
        // stop the card
        let myExpectation = expectation(description: "cancel() should finish within \(DroneCardKitTests.nonEndingCardProcessTime) seconds")
        DispatchQueue.global(qos: .default).async {
            takeTimelapse.cancel()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
        
            // assert!
            XCTAssertTrue(takeTimelapse.errors.count == 0)
            takeTimelapse.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(cameraToken.calledFunctions.contains("startTimelapse"), "startTimelapse should have been called")
            XCTAssertTrue(cameraToken.calledFunctions.contains("stopTimelapse"), "stopTimelapse should have been called")
            XCTAssertTrue(cameraToken.calledFunctions.count == 2, "only two methods should have been called (start and stop)")
            
            XCTAssertTrue(takeTimelapse.yieldData.count == 1, "takeTimelapse should yield a video")
            
            guard let yieldData = takeTimelapse.yieldData.first?.data else {
                XCTFail("takeTimelapse yield has no data")
                return
            }
            
            do {
                let _ = try yieldData.decode(type: DCKVideo.self)
            } catch let error {
                XCTFail("failed to decode DCKVideo from yield: \(error)")
            }
        }
    }
}
