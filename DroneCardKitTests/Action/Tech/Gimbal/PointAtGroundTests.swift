//
//  PointAtGroundTests.swift
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

class PointAtGroundTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPointAtGround() {
        // executable card
        let pointAtGround = PointAtGround(with: DroneCardKit.Action.Tech.Gimbal.PointAtGround.makeCard())
        
        // bind inputs and tokens
        let gimbalToken = DummyGimbalToken(with: DroneCardKit.Token.Gimbal.makeCard())
        let inputBindings: [String : JSONEncodable] = [:]
        let tokenBindings = ["Gimbal": gimbalToken]
        
        pointAtGround.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "test completion")
        
        DispatchQueue.global(qos: .default).async {
            pointAtGround.main()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(pointAtGround.errors.count == 0)
            pointAtGround.errors.forEach { XCTFail("\($0.localizedDescription)") }
            
            XCTAssertTrue(gimbalToken.calledFunctions.contains("rotate"), "rotate should have been called")
            XCTAssertTrue(gimbalToken.calledFunctions.count == 1, "only one method should have been called")
        }
    }
}
