//
//  MavlinkDroneToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 9/23/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//import CardKit

//import Mavlink

public class MavlinkDroneToken: DroneToken {
    
    public func takeOff() {
        print("drone taking off!")
    }
    
    public func fly(to coordinate: DCKCoordinate3D) {
        print("drone flying to: \(coordinate)")
    }
    
    public func fly(to coordinate: DCKCoordinate2D) {
        print("drone flying to: \(coordinate)")
    }
    
    public func returnHome() {
        print("drone returning home!")
    }
    
    public func land() {
        print("drone landing!")
    }
}
