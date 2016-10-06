//
//  DroneToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 9/23/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class DroneToken: ExecutableTokenCard {
    func takeOff() {
        fatalError("cannot call takeOff() on DroneToken")
    }
    
    func takeOff(climbingTo altitude: Double) {
        fatalError("cannot call takeOff(climbingTo:) on DroneToken")
    }
    
    func fly(to coordinate: DCKCoordinate2D, atSpeed speed: Double = 2.0) {
        fatalError("cannot call fly(to:atSpeed:) on DroneToken")
    }
    
    func fly(to coordinate: DCKCoordinate3D, atSpeed speed: Double = 2.0) {
        fatalError("cannot call fly(to:atSpeed:) on DroneToken")
    }
    
    func returnHome() {
        fatalError("cannot call returnHome() on DroneToken")
    }
    
    func land() {
        fatalError("cannot call land() on DroneToken")
    }
}
