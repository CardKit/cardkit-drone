//
//  TakePhotoTests.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 3/2/17.
//  Copyright © 2017 IBM. All rights reserved.
//

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
        let quality = DCKPhotoQuality.excellent
        let inputBindings: [String : Codable] = ["AspectRatio": aspectRatio, "Quality": quality]
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
        let quality = DCKPhotoQuality.excellent
        let inputBindings: [String : Codable] = ["HDR": hdr, "AspectRatio": aspectRatio, "Quality": quality]
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
