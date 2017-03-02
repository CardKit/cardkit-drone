//
//  HoverTests.swift
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

class HoverTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHover() {
        // executable card
        let hover = Hover(with: DroneCardKit.Action.Movement.Simple.Hover.makeCard())
        
        // bind inputs and tokens
        let droneToken = DummyDroneToken(with: DroneCardKit.Token.Drone.makeCard())
        let inputBindings: [String : JSONEncodable] = ["Altitude": DCKDistance(meters: 10.0)]
        let tokenBindings = ["Drone": droneToken]
        
        hover.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "test completion")
        
        DispatchQueue.global(qos: .default).async {
            hover.main()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(hover.errors.count == 0)
            hover.errors.forEach { XCTFail("\($0.localizedDescription)") }
            
            XCTAssertTrue(droneToken.calledFunctions.contains("hover"), "hover should have been called")
            XCTAssertTrue(droneToken.calledFunctions.count == 1, "only one card should have been called")
        }
    }
}
