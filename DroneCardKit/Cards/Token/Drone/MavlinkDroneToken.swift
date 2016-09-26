//
//  MavlinkDroneToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 9/23/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

//import Mavlink

public class MavlinkDroneToken: DroneToken {
    
    public override func takeOff() {
        print("drone taking off!")
    }
    
    public override func takeOff(climbingTo altitude: Double) {
        print("drone taking off and climbing to altitude \(altitude)")
    }
    
    public override func fly(to coordinate: DCKCoordinate3D, atSpeed speed: Double = 2.0) {
        print("drone flying to: \(coordinate)")
    }
    
    public override func fly(to coordinate: DCKCoordinate2D, atSpeed speed: Double = 2.0) {
        print("drone flying to: \(coordinate)")
    }
    
    public override func returnHome() {
        print("drone returning home!")
    }
    
    public override func land() {
        print("drone landing!")
    }
}
