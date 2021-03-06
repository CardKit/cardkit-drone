/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XCTest

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
        let droneToken = MockDroneToken(with: DroneCardKit.Token.Drone.makeCard())
        let inputBindings: [String: Codable] = ["Altitude": DCKRelativeAltitude(metersAboveGroundAtTakeoff: 10), "Speed": DCKSpeed(metersPerSecond: 1)]
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
            XCTAssertTrue(droneToken.calledFunctions.contains("flyTo"), "flyTo should have been called")
            XCTAssertTrue(droneToken.calledFunctions.contains("land"), "land should have been called")
        }
    }
}
