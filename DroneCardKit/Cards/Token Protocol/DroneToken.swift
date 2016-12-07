//
//  DroneToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 9/23/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit
import CardKitRuntime

import PromiseKit

public protocol DroneToken {
    func areMotorsOn() -> Promise<Bool>
    func motors(on: Bool) -> Promise<Void>
    
    func currentLocation() -> Promise<DCKCoordinate3D>
    func currentOrientation() -> Promise<DCKOrientation>
    
    func hover(withYaw yaw: DCKAngle?) -> Promise<Void>
    
    func fly(to altitude: DCKAltitude, withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void>
    func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKAltitude?, withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void>
    func fly(on path: DCKCoordinate2DPath, atSpeed speed: DCKVelocity?) -> Promise<Void>
    func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKVelocity?) -> Promise<Void>
    
    func setHome(location: DCKCoordinate2D)
    func homeLocation() -> Promise<DCKCoordinate2D>
    func returnHome(to altitude: DCKAltitude?, withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void>
    
    func landingGear(down: Bool) -> Promise<Void>
    
    func land() -> Promise<Void>
}

public extension DroneToken {
    
    final func fly(to altitude: DCKAltitude) -> Promise<Void> {
        return fly(to: altitude, withYaw: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D) -> Promise<Void> {
        return fly(to: coordinate, atAltitude: nil, withYaw: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate3D) -> Promise<Void> {
        return fly(to: coordinate.as2D, atAltitude: coordinate.altitude, withYaw: nil, atSpeed: nil)
    }
    
//    func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKAltitude?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
//        return fly(DCKCoordinate3D(coordinate: coordinate, altitude: altitude))
//    }
    
}
