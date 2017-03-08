//
//  CoverAreaTests.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 3/1/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest

import Freddy

@testable import CardKit
@testable import CardKitRuntime
@testable import DroneCardKit

class CoverAreaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // swiftlint:disable:next function_body_length
    func testCoverArea() {
        // executable card
        let coverArea = CoverArea(with: DroneCardKit.Action.Movement.Area.CoverArea.makeCard())
        
        // bind inputs and tokens
        let droneToken = MockDroneToken(with: DroneCardKit.Token.Drone.makeCard())
        let area = DCKCoordinate2DPath(path: [
            DCKCoordinate2D(latitude: 41.45782443982217, longitude: -73.29261755536784),
            DCKCoordinate2D(latitude: 41.45671972574724, longitude: -73.29207348324675),
            DCKCoordinate2D(latitude: 41.45582229042331, longitude: -73.2913601825892),
            DCKCoordinate2D(latitude: 41.45543334024571, longitude: -73.29183860865763),
            DCKCoordinate2D(latitude: 41.45463191071634, longitude: -73.2917372469897),
            DCKCoordinate2D(latitude: 41.45419850774147, longitude: -73.29187846291759),
            DCKCoordinate2D(latitude: 41.45404314279999, longitude: -73.2920556642635),
            DCKCoordinate2D(latitude: 41.45352428224452, longitude: -73.2918256172247),
            DCKCoordinate2D(latitude: 41.45358144816588, longitude: -73.29119143245306),
            DCKCoordinate2D(latitude: 41.45339150594869, longitude: -73.29085387105235),
            DCKCoordinate2D(latitude: 41.4536763059257, longitude: -73.29041560996949),
            DCKCoordinate2D(latitude: 41.45409105095059, longitude: -73.29009003823403),
            DCKCoordinate2D(latitude: 41.45402860645554, longitude: -73.28975515939536),
            DCKCoordinate2D(latitude: 41.45381847201313, longitude: -73.28971493076274),
            DCKCoordinate2D(latitude: 41.45364037160834, longitude: -73.28948297650446),
            DCKCoordinate2D(latitude: 41.45355111490382, longitude: -73.28902501306048),
            DCKCoordinate2D(latitude: 41.45356221343098, longitude: -73.28848709684037),
            DCKCoordinate2D(latitude: 41.45362677881502, longitude: -73.28808055725158),
            DCKCoordinate2D(latitude: 41.4538063973752, longitude: -73.28752206344512),
            DCKCoordinate2D(latitude: 41.45407676789414, longitude: -73.28620489021689),
            DCKCoordinate2D(latitude: 41.45436536739595, longitude: -73.2859873341003),
            DCKCoordinate2D(latitude: 41.45472833746008, longitude: -73.28596453283241),
            DCKCoordinate2D(latitude: 41.45502725013488, longitude: -73.28647810376108),
            DCKCoordinate2D(latitude: 41.45575957654543, longitude: -73.28623104192918),
            DCKCoordinate2D(latitude: 41.4561292051625, longitude: -73.28576351469401),
            DCKCoordinate2D(latitude: 41.45648221440739, longitude: -73.28562340559954),
            DCKCoordinate2D(latitude: 41.45677746143469, longitude: -73.28584264463105),
            DCKCoordinate2D(latitude: 41.45755065122419, longitude: -73.28597855626801),
            DCKCoordinate2D(latitude: 41.45765593447224, longitude: -73.28652451076739),
            DCKCoordinate2D(latitude: 41.45819691342534, longitude: -73.28674018805917),
            DCKCoordinate2D(latitude: 41.45831951063382, longitude: -73.2879074021711),
            DCKCoordinate2D(latitude: 41.45782443982217, longitude: -73.29261755536784)])
        let altitude = DCKRelativeAltitude(metersAboveGroundAtTakeoff: 10)
        let speed = DCKSpeed(metersPerSecond: 2)
        let inputBindings: [String : JSONEncodable] = ["Area": area, "Altitude": altitude, "Speed": speed]
        let tokenBindings = ["Drone": droneToken]
        
        coverArea.setup(inputBindings: inputBindings, tokenBindings: tokenBindings)
        
        // execute
        let myExpectation = expectation(description: "test completion")
        
        DispatchQueue.global(qos: .default).async {
            coverArea.main()
            myExpectation.fulfill()
        }
        
        // wait for card to finish
        waitForExpectations(timeout: DroneCardKitTests.expectationTimeout) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
            
            // assert!
            XCTAssertTrue(coverArea.errors.count == 0)
            coverArea.errors.forEach { XCTFail("\($0)") }
            
            /*XCTAssertTrue(droneToken.calledFunctions.contains("fly"), "coverArea should have been called")
            XCTAssertTrue(droneToken.calledFunctions.count == 1, "only one method should have been called")*/
        }
    }
}
