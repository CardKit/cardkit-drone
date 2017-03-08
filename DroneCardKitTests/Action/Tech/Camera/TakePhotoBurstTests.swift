//
//  TakePhotoBurstTests.swift
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

class TakePhotoBurstTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTakePhotoBurst() {
        // executable card
        let takePhotoBurst = TakePhotoBurst(with: DroneCardKit.Action.Tech.Camera.TakePhotoBurst.makeCard())
        
        // bind inputs and tokens
        let cameraToken = MockCameraToken(with: DroneCardKit.Token.Camera.makeCard())
        let burstCount = PhotoBurstCount.burst_3
        let aspectRatio = PhotoAspectRatio.aspect_16x9
        let quality = PhotoQuality.excellent
        let inputBindings: [String : JSONEncodable] = ["BurstCount": burstCount, "AspectRatio": aspectRatio, "Quality": quality]
        let tokenBindings = ["Camera": cameraToken]
        
        takePhotoBurst.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "card should finish within \(DroneCardKitTests.nonEndingCardProcessTime) seconds")
        
        DispatchQueue.global(qos: .default).async {
            takePhotoBurst.main()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(takePhotoBurst.errors.count == 0)
            takePhotoBurst.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(cameraToken.calledFunctions.contains("takePhotoBurst"), "takePhotoBurst should have been called")
            
            XCTAssertTrue(takePhotoBurst.yieldData.count == 1, "takePhotoBurst should yield a photo burst")
            
            guard let yieldData = takePhotoBurst.yieldData.first?.data else {
                XCTFail("takePhotoBurst yield has no data")
                return
            }
            
            do {
                let _ = try yieldData.decode(type: DCKPhotoBurst.self)
            } catch let error {
                XCTFail("failed to decode DCKPhotoBurst from yield: \(error)")
            }
        }
    }
}
