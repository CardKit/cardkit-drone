//
//  PointInDirectionTests.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 3/2/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest

@testable import CardKit
@testable import CardKitRuntime
@testable import DroneCardKit

class PointInDirectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPointInDirection() {
        // executable card
        let pointInDirection = PointInDirection(with: DroneCardKit.Action.Tech.Gimbal.PointInDirection.makeCard())
        
        // bind inputs and tokens
        let gimbalToken = MockGimbalToken(with: DroneCardKit.Token.Gimbal.makeCard())
        let telemetryToken = MockTelemetryToken(with: DroneCardKit.Token.Telemetry.makeCard())
        let direction: DCKCardinalDirection = .north
        let inputBindings: [String : Codable] = ["CardinalDirection": direction]
        let tokenBindings = ["Gimbal": gimbalToken, "Telemetry": telemetryToken]
        
        pointInDirection.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "test completion")
        
        DispatchQueue.global(qos: .default).async {
            pointInDirection.main()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(pointInDirection.errors.count == 0)
            pointInDirection.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(gimbalToken.calledFunctions.contains("rotate"), "rotate should have been called")
        }
    }
}
