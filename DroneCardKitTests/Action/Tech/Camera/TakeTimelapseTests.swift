/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XCTest

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
        let cameraToken = MockCameraToken(with: DroneCardKit.Token.Camera.makeCard())
        let aspectRatio: DCKPhotoAspectRatio = .aspect16x9
        let inputBindings: [String: Codable] = ["AspectRatio": aspectRatio]
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
            
            guard let video: DCKVideo = yieldData.unboxedValue() else {
                XCTFail("unable to unbox yielded DCKVideo")
                return
            }
            
            XCTAssertTrue(video.durationInSeconds > 0)
        }
    }
}
