//
//  FlyPathTests.swift
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

class FlyPathTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFlyPath() {
        // executable card
        let flyPath = FlyPath(with: DroneCardKit.Action.Movement.Sequence.FlyPath.makeCard())
        
        // bind inputs and tokens
        let droneToken = DummyDroneToken(with: DroneCardKit.Token.Drone.makeCard())
        let path = DCKCoordinate2DPath(path: [
            DCKCoordinate2D(latitude: 41.45782443982217, longitude: -73.29261755536784),
            DCKCoordinate2D(latitude: 41.45671972574724, longitude: -73.29207348324675),
            DCKCoordinate2D(latitude: 41.45582229042331, longitude: -73.2913601825892)])
        let inputBindings: [String : JSONEncodable] = ["Path": path, "Altitude": DCKRelativeAltitude(metersAboveGroundAtTakeoff: 10), "Speed": DCKSpeed(metersPerSecond: 1), "PauseDuration": 1.0]
        let tokenBindings = ["Drone": droneToken]
        
        flyPath.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "test completion")
        
        DispatchQueue.global(qos: .default).async {
            flyPath.main()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(flyPath.errors.count == 0)
            flyPath.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(droneToken.calledFunctions.contains("takeOff"), "takeOff should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("spinMotors"), "spinMotors should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("landingGear"), "landingGear should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("flyTo"), "flyTo should have been called")
        }
    }
}
