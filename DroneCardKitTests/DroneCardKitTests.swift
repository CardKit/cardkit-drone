//
//  DroneCardKitTests.swift
//  DroneCardKitTests
//
//  Created by Justin Weisz on 7/26/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest
@testable import DroneCardKit

class DroneCardKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is ca lled after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCardinalDirectionAzimuth() {
        for angle in 1 ... 360 {
            //let randomCompassAngleDegrees: Double = Double(arc4random_uniform(359))
//            let randomCompassAngle = DCKAngle(degrees: randomCompassAngleDegrees)
            let randomCompassAngle = DCKAngle(degrees: Double(angle))
            let direction: DCKCardinalDirection = DCKCardinalDirection.byAngle(randomCompassAngle)
            
            print("testing angle \(randomCompassAngle.degrees) degrees, \(direction) [\(direction.min()), \(direction.max()))")
            
            assert(direction.min() <= randomCompassAngle,
                   "direction minimum angle \(direction.max().degrees) degrees must be less than or equal to compass angle \(randomCompassAngle.degrees) degrees")
            assert(direction.max() >= randomCompassAngle,
                   "direction maximum angle \(direction.max().degrees) degrees must be greater than or equal to compass angle \(randomCompassAngle.degrees) degrees")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
