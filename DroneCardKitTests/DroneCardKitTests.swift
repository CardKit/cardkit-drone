//
//  DroneCardKitTests.swift
//  DroneCardKitTests
//
//  Created by Justin Weisz on 7/26/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest
@testable import DroneCardKit

@testable import DroneCardKit

class DroneCardKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testAllCardsGrouped() {
        let cards = DroneCardKit.allCardsGrouped()
        print("cards grouped: \(cards) \n\n\n")
        print("Movement Simple Cards : \(cards["Action/Movement/Simple"])")
        XCTAssertNotNil(cards)
    }
}
