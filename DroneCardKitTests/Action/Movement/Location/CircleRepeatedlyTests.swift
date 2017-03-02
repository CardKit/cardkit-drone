//
//  CircleRepeatedlyTests.swift
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

class CircleRepeatedlyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCircleRepeatedly() {
        // executable card
        let circleRepeatedly = CircleRepeatedly(with: DroneCardKit.Action.Movement.Location.CircleRepeatedly.makeCard())
        
        // bind inputs and tokens
        let droneToken = DummyDroneToken(with: DroneCardKit.Token.Drone.makeCard())
        let inputBindings: [String : JSONEncodable] = ["Center": DCKCoordinate2D(latitude: 41.45782443982217, longitude: -73.29261755536784), "Radius": DCKDistance(meters: 10), "Altitude": DCKRelativeAltitude(metersAboveGroundAtTakeoff: 10), "AngularSpeed": DCKAngularVelocity(degreesPerSecond: 5), "Direction": DCKRotationDirection.clockwise]
        let tokenBindings = ["Drone": droneToken]
        
        circleRepeatedly.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        DispatchQueue.global(qos: .default).async {
            circleRepeatedly.main()
        }
        
        // give the card some time to process
        Thread.sleep(forTimeInterval: DroneCardKitTests.nonEndingCardProcessTime)
        
        // stop the card
        let myExpectation = expectation(description: "cancel() should finish within \(DroneCardKitTests.nonEndingCardProcessTime) seconds")
        DispatchQueue.global(qos: .default).async {
            circleRepeatedly.cancel()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(circleRepeatedly.errors.count == 0)
            circleRepeatedly.errors.forEach { XCTFail("\($0.localizedDescription)") }
            
            XCTAssertTrue(droneToken.calledFunctions.contains("takeOff"), "takeOff should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("spinMotors"), "spinMotors should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("landingGear"), "landingGear should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("circle"), "circle should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("land"), "land should have been called")
            XCTAssertTrue(droneToken.calledFunctions.count == 5)
        }
    }
}
