//
//  TakePhotoTests.swift
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
        let cameraToken = DummyCameraToken(with: DroneCardKit.Token.Camera.makeCard())
        let hdr = true
        let aspectRatio = PhotoAspectRatio.aspect_16x9
        let quality = PhotoQuality.excellent
        let inputBindings: [String : JSONEncodable] = ["HDR": hdr, "AspectRatio": aspectRatio, "Quality": quality]
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
            takePhoto.errors.forEach { XCTFail("\($0.localizedDescription)") }
            
            XCTAssertTrue(cameraToken.calledFunctions.contains("takePhoto"), "takePhoto should have been called")
            XCTAssertTrue(cameraToken.calledFunctions.count == 1, "only one method should have been called")
            
            XCTAssertTrue(takePhoto.yieldData.count == 1, "takePhoto should yield a photo")
            
            guard let yieldData = takePhoto.yieldData.first?.data else {
                XCTFail("takePhoto yield has no data")
                return
            }
            
            do {
                let _ = try yieldData.decode(type: DCKPhoto.self)
            } catch let error {
                XCTFail("failed to decode DCKPhoto from yield: \(error)")
            }
        }
    }
}
