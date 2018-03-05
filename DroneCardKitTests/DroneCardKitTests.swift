//
//  DroneCardKitTests.swift
//  DroneCardKitTests
//
//  Created by Justin Weisz on 7/26/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest

@testable import CardKit
@testable import DroneCardKit

class DroneCardKitTests: XCTestCase {
    
    public static let expectationTimeout: TimeInterval = 20
    public static let nonEndingCardProcessTime: TimeInterval = 10
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
