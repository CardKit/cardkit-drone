//
//  InputTypeTests.swift
//  DroneCardKit
//
//  Created by ismails on 3/13/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest

@testable import CardKit
@testable import CardKitRuntime
@testable import DroneCardKit

class InputTypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllValuesEnum() {
        var valuesCount = DCKCardinalDirection.values.count
        XCTAssert(valuesCount == 32)
        
        valuesCount = DCKRotationDirection.values.count
        XCTAssert(valuesCount == 2)
        
        valuesCount = DCKPhotoAspectRatio.values.count
        XCTAssert(valuesCount == 3)
        
        valuesCount = DCKPhotoQuality.values.count
        XCTAssert(valuesCount == 3)
        
        valuesCount = DCKPhotoBurstCount.values.count
        XCTAssert(valuesCount == 5)
        
        valuesCount = DCKVideoResolution.values.count
        XCTAssert(valuesCount == 13)
        
        valuesCount = DCKVideoFramerate.values.count
        XCTAssert(valuesCount == 13)
    }

}