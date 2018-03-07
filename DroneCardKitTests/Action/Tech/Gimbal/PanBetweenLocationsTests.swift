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

class PanBetweenLocationsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPanBetweenLocations() {
        // executable card
        let panBetweenLocations = PanBetweenLocations(with: DroneCardKit.Action.Tech.Gimbal.PanBetweenLocations.makeCard())
        
        // bind inputs and tokens
        let gimbalToken = MockGimbalToken(with: DroneCardKit.Token.Gimbal.makeCard())
        let telemetryToken = MockTelemetryToken(with: DroneCardKit.Token.Telemetry.makeCard())
        let startLocation = DCKCoordinate3D(latitude: 41.45782443982217, longitude: -73.29261755536784, altitude: DCKRelativeAltitude(metersAboveGroundAtTakeoff: 10))
        let endLocation = DCKCoordinate3D(latitude: 41.4538063973752, longitude: -73.28752206344512, altitude: DCKRelativeAltitude(metersAboveGroundAtTakeoff: 10))
        let duration = 2.0
        let inputBindings: [String: Codable] = ["StartLocation": startLocation, "EndLocation": endLocation, "Duration": duration]
        let tokenBindings = ["Gimbal": gimbalToken, "Telemetry": telemetryToken]
        
        panBetweenLocations.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        DispatchQueue.global(qos: .default).async {
            panBetweenLocations.main()
        }
        
        // give the card some time to process
        Thread.sleep(forTimeInterval: DroneCardKitTests.nonEndingCardProcessTime)
        
        // stop the card
        let myExpectation = expectation(description: "cancel() should finish within \(DroneCardKitTests.nonEndingCardProcessTime) seconds")
        DispatchQueue.global(qos: .default).async {
            panBetweenLocations.cancel()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(panBetweenLocations.errors.count == 0)
            panBetweenLocations.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(gimbalToken.calledFunctions.contains("rotate"), "rotate should have been called")
        }
    }
}
