//
//  ReturnHomeTests.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 3/1/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest

import Freddy

@testable import CardKit
@testable import CardKitRuntime
@testable import DroneCardKit

class ReturnHomeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReturnHome() {
        // executable card
        let returnHome = ReturnHome(with: DroneCardKit.Action.Movement.Location.ReturnHome.makeCard())
        
        // bind inputs and tokens
        let droneToken = DummyDroneToken(with: DroneCardKit.Token.Drone.makeCard())
        let inputBindings: [String : JSONEncodable] = ["Altitude": DCKRelativeAltitude(metersAboveGroundAtTakeoff: 10), "Speed": DCKSpeed(metersPerSecond: 1)]
        let tokenBindings = ["Drone": droneToken]
        
        returnHome.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "test completion")
        
        DispatchQueue.global(qos: .default).async {
            returnHome.main()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(returnHome.errors.count == 0)
            returnHome.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(droneToken.calledFunctions.contains("returnHome"), "returnHome should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("fly"), "fly should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("land"), "land should have been called")
        }
    }
}
