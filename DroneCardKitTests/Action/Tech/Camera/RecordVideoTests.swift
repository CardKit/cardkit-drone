//
//  RecordVideoTests.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 3/1/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest

@testable import CardKit
@testable import CardKitRuntime
@testable import DroneCardKit

class RecordVideoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRecordVideo() {
        // executable card
        let recordVideo = RecordVideo(with: DroneCardKit.Action.Tech.Camera.RecordVideo.makeCard())
        
        // bind inputs and tokens
        let cameraToken = MockCameraToken(with: DroneCardKit.Token.Camera.makeCard())
        let framerate: DCKVideoFramerate = .framerate30fps
        let resolution: DCKVideoResolution = .resolution1080p
        let inputBindings: [String : Codable] = ["Framerate": framerate, "Resolution": resolution, "SlowMotionEnabled": false]
        let tokenBindings = ["Camera": cameraToken]
        
        recordVideo.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        DispatchQueue.global(qos: .default).async {
            recordVideo.main()
        }
        
        // give the card some time to process
        Thread.sleep(forTimeInterval: DroneCardKitTests.nonEndingCardProcessTime)
        
        // stop the card
        let myExpectation = expectation(description: "cancel() should finish within \(DroneCardKitTests.nonEndingCardProcessTime) seconds")
        DispatchQueue.global(qos: .default).async {
            recordVideo.cancel()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(recordVideo.errors.count == 0)
            recordVideo.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(cameraToken.calledFunctions.contains("startVideo"), "startRecordVideo should have been called")
            XCTAssertTrue(cameraToken.calledFunctions.contains("stopVideo"), "stopRecordVideo should have been called")
            
            XCTAssertTrue(recordVideo.yieldData.count == 1, "recordVideo should yield a video")
            
            guard let yieldData = recordVideo.yieldData.first?.data else {
                XCTFail("recordVideo yield has no data")
                return
            }
            
            guard let video: DCKVideo = yieldData.unboxedValue() else {
                XCTFail("unable to unbox yielded DCKVideo")
                return
            }
            
            XCTAssertTrue(video.sizeInBytes > 0)
        }
    }
}
