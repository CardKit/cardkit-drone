//
//  PointAtLocationTests.swift
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

class PointAtLocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPointAtLocation() {
        // executable card
        let pointAtLocation = PointAtLocation(with: DroneCardKit.Action.Tech.Gimbal.PointAtLocation.makeCard())
        
        // bind inputs and tokens
        let gimbalToken = DummyGimbalToken(with: DroneCardKit.Token.Gimbal.makeCard())
        let telemetryToken = DummyTelemetryToken(with: DroneCardKit.Token.Telemetry.makeCard())
        let location = DCKCoordinate3D(latitude: 41.45782443982217, longitude: -73.29261755536784, altitude: 10)
        let inputBindings: [String : JSONEncodable] = ["Location": location]
        let tokenBindings = ["Gimbal": gimbalToken, "Telemetry": telemetryToken]
        
        pointAtLocation.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "test completion")
        
        DispatchQueue.global(qos: .default).async {
            pointAtLocation.main()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(pointAtLocation.errors.count == 0)
            pointAtLocation.errors.forEach { XCTFail("\($0.localizedDescription)") }
            
            XCTAssertTrue(gimbalToken.calledFunctions.contains("rotate"), "rotate should have been called")
            XCTAssertTrue(gimbalToken.calledFunctions.count == 1, "only one method should have been called")
        }
    }
}
