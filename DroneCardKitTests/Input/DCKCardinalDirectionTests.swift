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

class DCKCardinalDirectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAzimuth() {
        let directionRangeDegrees: Double = 360 / 32.0
        
        for angleDegrees in stride(from: 0, to: 720, by: 7.12345) {
            let angle = DCKAngle(degrees: Double(angleDegrees))
            let direction: DCKCardinalDirection = DCKCardinalDirection.byAngle(angle)
            
            print("testing angle \(angle.degrees) degrees, \(direction) [\(direction.min), \(direction.max))")
            
            assert((angle - direction.min).normalized().degrees <= directionRangeDegrees,
                   "direction minimum angle \(direction.max.degrees) too far from compass angle \(angle.degrees) degrees")
            assert((direction.max - angle).normalized().degrees <= directionRangeDegrees,
                   "direction maximum angle \(direction.max.degrees) too far from compass angle \(angle.degrees) degrees")
        }
    }
}
