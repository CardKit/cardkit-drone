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

class TakePhotosTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTakePhotos() {
        // executable card
        let takePhotos = TakePhotos(with: DroneCardKit.Action.Tech.Camera.TakePhotos.makeCard())
        
        // bind inputs and tokens
        let cameraToken = MockCameraToken(with: DroneCardKit.Token.Camera.makeCard())
        let frequency: TimeInterval = 1.0
        let aspectRatio = DCKPhotoAspectRatio.aspect16x9
        let inputBindings: [String: Codable] = ["Frequency": frequency, "AspectRatio": aspectRatio]
        let tokenBindings = ["Camera": cameraToken]
        
        takePhotos.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        DispatchQueue.global(qos: .default).async {
            takePhotos.main()
        }
        
        // give the card some time to process
        Thread.sleep(forTimeInterval: DroneCardKitTests.nonEndingCardProcessTime)
        
        // stop the card
        let myExpectation = expectation(description: "cancel() should finish within \(DroneCardKitTests.nonEndingCardProcessTime) seconds")
        DispatchQueue.global(qos: .default).async {
            takePhotos.cancel()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(takePhotos.errors.count == 0)
            takePhotos.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(cameraToken.calledFunctions.contains("startTakingPhotos"), "startTakingPhotos should have been called")
            XCTAssertTrue(cameraToken.calledFunctions.contains("stopTakingPhotos"), "stopTakingPhotos should have been called")
            
            XCTAssertTrue(takePhotos.yieldData.count == 1, "takePhotos should yield a photo burst")
            
            guard let yieldData = takePhotos.yieldData.first?.data else {
                XCTFail("takePhotos yield has no data")
                return
            }
            
            guard let burst: DCKPhotoBurst = yieldData.unboxedValue() else {
                XCTFail("unable to unbox yielded DCKPhotoBurst")
                return
            }
            XCTAssertTrue(burst.photos.count > 0, "should have taken at least one photo")
            XCTAssertTrue(burst.photos.count <= 5, "should not have taken more than 5 photos within 5 seconds at a 1 second interval")
        }
    }
}
