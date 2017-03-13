//
//  PointAtFrontTests.swift
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

class PointAtFrontTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPointAtFront() {
        // executable card
        let pointAtFront = PointAtFront(with: DroneCardKit.Action.Tech.Gimbal.PointAtFront.makeCard())
        
        // bind inputs and tokens
        let gimbalToken = MockGimbalToken(with: DroneCardKit.Token.Gimbal.makeCard())
        let inputBindings: [String : JSONEncodable] = [:]
        let tokenBindings = ["Gimbal": gimbalToken]
        
        pointAtFront.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "test completion")
        
        DispatchQueue.global(qos: .default).async {
            pointAtFront.main()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(pointAtFront.errors.count == 0)
            pointAtFront.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(gimbalToken.calledFunctions.contains("orient"), "orient should have been called")
        }
    }
}