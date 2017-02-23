//
//  DCKOrientedCoordinate3DTests.swift
//  DroneCardKit
//
//  Created by ismails on 2/23/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import XCTest
import Foundation

@testable import CardKit
@testable import CardKitRuntime
@testable import DroneCardKit

class DCKOrientedCoordinate3DTests: XCTestCase {
    
    func testAddDistance() {
        let errorMsg = "new distance does not equal expected amount"
        let coordinate = DCKCoordinate2D(latitude: 50.066, longitude:  -5.714)
        let distance = DCKDistance(meters: 20)
        
        // test adding distance with a yaw of 0 degrees
        let locationFacingN = DCKOrientedCoordinate3D(coordinate2D: coordinate, altitude: 10.0, yaw: DCKAngle(degrees: 0))
        let newLocationFacingN = locationFacingN.add(distance: distance) // we are testing the add func
        XCTAssert(newLocationFacingN.latitude > coordinate.latitude, "new latitude should be less than original longitude since the drone moved north")
        XCTAssert(newLocationFacingN.longitude == coordinate.longitude, "longitudes should be equal since the drone did not move horizontally")
        
        let distanceBetweenTwoN = coordinate.distance(to: newLocationFacingN)
        XCTAssert(isDistance(distanceBetweenTwoN, equalTo: distance.meters), errorMsg)
        
        
        // test adding distance with a yaw of 180 degrees
        let locationFacingS = DCKOrientedCoordinate3D(coordinate2D: coordinate, altitude: 10.0, yaw: DCKAngle(degrees: 180))
        let newLocationFacingS = locationFacingS.add(distance: distance) // we are testing the add func
        XCTAssert(newLocationFacingS.latitude < coordinate.latitude, "new latitude should be greater than original longitude since the drone moved south")
        XCTAssert(newLocationFacingS.longitude == coordinate.longitude, "longitudes should be equal since the drone did not move horizontally")
        
        let distanceBetweenTwoS = coordinate.distance(to: newLocationFacingS)
        XCTAssert(isDistance(distanceBetweenTwoS, equalTo: distance.meters), errorMsg)
        
        
        // test adding distance with a yaw of 90 degrees
        let locationFacingE = DCKOrientedCoordinate3D(coordinate2D: coordinate, altitude: 10.0, yaw: DCKAngle(degrees: 90))
        let newLocationFacingE = locationFacingE.add(distance: distance) // we are testing the add func
        XCTAssert(newLocationFacingE.latitude == coordinate.latitude, "latitudes should be equal since the drone did not move vertically")
        XCTAssert(newLocationFacingE.longitude > coordinate.longitude, "new longitude should be greater than original longitude since the drone moved east")
        
        let distanceBetweenTwoE = coordinate.distance(to: newLocationFacingE)
        XCTAssert(isDistance(distanceBetweenTwoE, equalTo: distance.meters), errorMsg)
        
        
        // test adding distance with a yaw of 270 degrees
        let locationFacingW = DCKOrientedCoordinate3D(coordinate2D: coordinate, altitude: 10.0, yaw: DCKAngle(degrees: 270))
        let newLocationFacingW = locationFacingW.add(distance: distance) // we are testing the add func
        XCTAssert(newLocationFacingW.latitude == coordinate.latitude, "latitudes should be equal since the drone did not move vertically")
        XCTAssert(newLocationFacingW.longitude < coordinate.longitude, "new longitude should be less than original longitude since the drone moved west")
        
        let distanceBetweenTwoW = coordinate.distance(to: newLocationFacingW)
        XCTAssert(isDistance(distanceBetweenTwoW, equalTo: distance.meters), errorMsg)
        
        
        // test adding distance with yaw in quadrant 1 (0 to 90 degrees) (not inclusive)
        let locationFacingQ1 = DCKOrientedCoordinate3D(coordinate2D: coordinate, altitude: 10.0, yaw: DCKAngle(degrees: 35))
        let newLocationFacingQ1 = locationFacingQ1.add(distance: distance) // we are testing the add func
        XCTAssert(newLocationFacingQ1.latitude > coordinate.latitude, "new latitude should be greater than the original latitude since the drone moved north")
        XCTAssert(newLocationFacingQ1.longitude > coordinate.longitude, "new longitude should be greater than the original longitude since the drone moved east")
        
        let distanceBetweenTwoQ1 = coordinate.distance(to: newLocationFacingQ1)
        print(locationFacingQ1)
        print(newLocationFacingQ1)
        XCTAssert(isDistance(distanceBetweenTwoQ1, equalTo: distance.meters), errorMsg)
        
        
        // test adding distance with yaw in quadrant 2 (90 to 180 degrees) (not inclusive)
        let locationFacingQ2 = DCKOrientedCoordinate3D(coordinate2D: coordinate, altitude: 10.0, yaw: DCKAngle(degrees: 135))
        let newLocationFacingQ2 = locationFacingQ2.add(distance: distance) // we are testing the add func
        XCTAssert(newLocationFacingQ2.latitude < coordinate.latitude, "new latitude should be less than the original latitude since the drone moved south")
        XCTAssert(newLocationFacingQ2.longitude > coordinate.longitude, "new longitude should be greater than the original longitude since the drone moved east")
        
        let distanceBetweenTwoQ2 = coordinate.distance(to: newLocationFacingQ2)
        XCTAssert(isDistance(distanceBetweenTwoQ2, equalTo: distance.meters), errorMsg)
        
        
        // test adding distance with yaw in quadrant 3 (180 to 270 degrees) (not inclusive)
        let locationFacingQ3 = DCKOrientedCoordinate3D(coordinate2D: coordinate, altitude: 10.0, yaw: DCKAngle(degrees: 230))
        let newLocationFacingQ3 = locationFacingQ3.add(distance: distance) // we are testing the add func
        XCTAssert(newLocationFacingQ3.latitude < coordinate.latitude, "new latitude should be less than the original latitude since the drone moved south")
        XCTAssert(newLocationFacingQ3.longitude < coordinate.longitude, "new longitude should be less than the original longitude since the drone moved west")
        
        let distanceBetweenTwoQ3 = coordinate.distance(to: newLocationFacingQ3)
        XCTAssert(isDistance(distanceBetweenTwoQ3, equalTo: distance.meters), errorMsg)
        
        
        // test adding distance with yaw in quadrant 4 (270 to 360 degrees) (not inclusive)
        let locationFacingQ4 = DCKOrientedCoordinate3D(coordinate2D: coordinate, altitude: 10.0, yaw: DCKAngle(degrees: 300))
        let newLocationFacingQ4 = locationFacingQ4.add(distance: distance) // we are testing the add func
        XCTAssert(newLocationFacingQ4.latitude > coordinate.latitude, "new latitude should be greater than the original latitude since the drone moved north")
        XCTAssert(newLocationFacingQ4.longitude < coordinate.longitude, "new longitude should be less than the original longitude since the drone moved west")
        
        let distanceBetweenTwoQ4 = coordinate.distance(to: newLocationFacingQ4)
        XCTAssert(isDistance(distanceBetweenTwoQ4, equalTo: distance.meters), errorMsg)
    }
    
    public func isDistance(_ distance1: Double, equalTo distance2: Double) -> Bool {
        print("\(distance1) ==? \(distance2)")
        let threshold: Double = 0.01
        
        let difference = abs(distance2 - distance1)
        return difference < threshold
    }
}
