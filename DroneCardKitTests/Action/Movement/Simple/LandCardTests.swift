//
//  LandTests.swift
//  DroneCardKit
//
//  Created by ismails on 12/9/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest

@testable import CardKit    
@testable import CardKitRuntime
@testable import DroneCardKit
@testable import PromiseKit

class LandTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLand() {
        // setup land card
        let landCard = DroneCardKit.Action.Movement.Simple.Land.makeCard()
        let landExecutableCard = Land(with: landCard)
        
        // setup token
        let tokenCardDescriptor = TokenCardDescriptor(name: "Drone", subpath: nil, isConsumed: true, assetCatalog: CardAssetCatalog(description: "test"))
        let tokenCard = tokenCardDescriptor.makeCard()
        let tokenSlot = TokenSlot(name: "Drone", descriptor: tokenCardDescriptor)
        
        let tokenExecutableCard = TestDroneToken(with: tokenCard)
        //print(tokenExecutableCard as? DroneToken)
        
        landExecutableCard.setup([:], tokens: [tokenSlot: tokenExecutableCard])
       
        landExecutableCard.main()
        
        XCTAssert(tokenExecutableCard.funcCalled_land == true, "land should have been called")
    }
}
