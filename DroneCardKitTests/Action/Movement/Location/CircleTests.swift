//
//  CircleTests.swift
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

class CircleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCircle() {
        // executable card
        let circle = Circle(with: DroneCardKit.Action.Movement.Location.Circle.makeCard())
        
        // bind inputs and tokens
        let droneToken = DummyDroneToken(with: DroneCardKit.Token.Drone.makeCard())
        let inputBindings: [String : JSONEncodable] = ["Center": DCKCoordinate2D(latitude: 41.45782443982217, longitude: -73.29261755536784), "Radius": DCKDistance(meters: 10), "Altitude": DCKRelativeAltitude(metersAboveGroundAtTakeoff: 10), "AngularSpeed": DCKAngularVelocity(degreesPerSecond: 5), "Direction": DCKRotationDirection.clockwise]
        let tokenBindings = ["Drone": droneToken]
        
        circle.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "test completion")
        
        DispatchQueue.global(qos: .default).async {
            circle.main()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(circle.errors.count == 0)
            circle.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(droneToken.calledFunctions.contains("takeOff"), "takeOff should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("spinMotors"), "spinMotors should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("landingGear"), "landingGear should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("circle"), "circle should have been called")
        }
    }
}
