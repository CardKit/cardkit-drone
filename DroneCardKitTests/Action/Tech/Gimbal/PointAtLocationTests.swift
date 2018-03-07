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
        let gimbalToken = MockGimbalToken(with: DroneCardKit.Token.Gimbal.makeCard())
        let telemetryToken = MockTelemetryToken(with: DroneCardKit.Token.Telemetry.makeCard())
        let location = DCKCoordinate3D(latitude: 41.45782443982217, longitude: -73.29261755536784, altitude: DCKRelativeAltitude(metersAboveGroundAtTakeoff: 10))
        let inputBindings: [String: Codable] = ["Location": location]
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
            pointAtLocation.errors.forEach { XCTFail("\($0)") }
            
            XCTAssertTrue(gimbalToken.calledFunctions.contains("rotate"), "rotate should have been called")
        }
    }
}
