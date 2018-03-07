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

class TakePhotoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTakePhoto() {
        // executable card
        let takePhoto = TakePhoto(with: DroneCardKit.Action.Tech.Camera.TakePhoto.makeCard())
        
        // bind inputs and tokens
        let cameraToken = MockCameraToken(with: DroneCardKit.Token.Camera.makeCard())
        let aspectRatio = DCKPhotoAspectRatio.aspect16x9
        let inputBindings: [String: Codable] = ["AspectRatio": aspectRatio]
        let tokenBindings = ["Camera": cameraToken]
        
        takePhoto.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "card should finish within \(DroneCardKitTests.nonEndingCardProcessTime) seconds")
        
        DispatchQueue.global(qos: .default).async {
            takePhoto.main()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(takePhoto.errors.count == 0)
            takePhoto.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(cameraToken.calledFunctions.contains("takePhoto"), "takeHDRPhoto should have been called")
            
            XCTAssertTrue(takePhoto.yieldData.count == 1, "takePhoto should yield a photo")
            
            guard let yieldData = takePhoto.yieldData.first?.data else {
                XCTFail("takePhoto yield has no data")
                return
            }
            
            guard let photo: DCKPhoto = yieldData.unboxedValue() else {
                XCTFail("unable to unbox yielded DCKPhoto")
                return
            }
            
            XCTAssertTrue(photo.sizeInBytes > 0)
        }
    }
    
    func testTakeHDRPhoto() {
        // executable card
        let takePhoto = TakePhoto(with: DroneCardKit.Action.Tech.Camera.TakePhoto.makeCard())
        
        // bind inputs and tokens
        let cameraToken = MockCameraToken(with: DroneCardKit.Token.Camera.makeCard())
        let hdr = true
        let aspectRatio = DCKPhotoAspectRatio.aspect16x9
        let inputBindings: [String: Codable] = ["HDR": hdr, "AspectRatio": aspectRatio]
        let tokenBindings = ["Camera": cameraToken]
        
        takePhoto.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "card should finish within \(DroneCardKitTests.nonEndingCardProcessTime) seconds")
        
        DispatchQueue.global(qos: .default).async {
            takePhoto.main()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(takePhoto.errors.count == 0)
            takePhoto.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(cameraToken.calledFunctions.contains("takeHDRPhoto"), "takeHDRPhoto should have been called")
            
            XCTAssertTrue(takePhoto.yieldData.count == 1, "takePhoto should yield a photo")
            
            guard let yieldData = takePhoto.yieldData.first?.data else {
                XCTFail("takePhoto yield has no data")
                return
            }
            
            guard let photo: DCKPhoto = yieldData.unboxedValue() else {
                XCTFail("unable to unbox yielded DCKPhoto")
                return
            }
            
            XCTAssertTrue(photo.sizeInBytes > 0)
        }
    }
}
