//
//  HoverTests.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 3/1/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest

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
        let droneToken = MockDroneToken(with: DroneCardKit.Token.Drone.makeCard())
        let inputBindings: [String : Codable] = ["Altitude": DCKDistance(meters: 10.0)]
        let tokenBindings = ["Drone": droneToken]
        
        hover.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        DispatchQueue.global(qos: .default).async {
            hover.main()
        }
        
        // give the card some time to process
        Thread.sleep(forTimeInterval: DroneCardKitTests.nonEndingCardProcessTime)
        
        // stop the card
        let myExpectation = expectation(description: "cancel() should finish within \(DroneCardKitTests.nonEndingCardProcessTime) seconds")
        DispatchQueue.global(qos: .default).async {
            hover.cancel()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(hover.errors.count == 0)
            hover.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(droneToken.calledFunctions.contains("hover"), "hover should have been called")
        }
    }
}
