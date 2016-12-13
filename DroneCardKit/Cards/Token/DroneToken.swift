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
    // Location & attitude
    var currentLocation: DCKCoordinate3D? { get }
    var currentAttitude: DCKAttitude? { get }
    
    // Motor state
    var motorsAreOn: Bool? { get }
    func motorOnState() -> Promise<Bool>
    func turnMotorsOn() -> Promise<Void>
    func turnMotorsOff() -> Promise<Void>
    
    // Take off
    func takeOff() -> Promise<Void>
    
    // Hover
    func hover() -> Promise<Void>
    
    // Orient
    func orient(to yaw: DCKAngle) -> Promise<Void>
    func orient(to altitude: DCKAltitude) -> Promise<Void>
    
    // Fly
    func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKAltitude?, atSpeed speed: DCKVelocity?) -> Promise<Void>
    func fly(to coordinate: DCKCoordinate3D, atSpeed speed: DCKVelocity?) -> Promise<Void>
    func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKAltitude?, atSpeed speed: DCKVelocity?) -> Promise<Void>
    func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKVelocity?) -> Promise<Void>
    
    // Return home
    var homeLocation: DCKCoordinate3D? { get }
    func returnHome(atAltitude altitude: DCKAltitude?, atSpeed speed: DCKVelocity?) -> Promise<Void>
    
    // Landing gear
    var isLandingGearDown: Bool? { get }
    func landingGear(down: Bool) -> Promise<Void>
    
    // Land
    func land() -> Promise<Void>
}

// MARK: Fly To variants

public extension DroneToken {
    final func fly(to coordinate: DCKCoordinate2D) -> Promise<Void> {
        return fly(to: coordinate, atAltitude: nil, atSpeed: nil)
    }
   
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKAltitude) -> Promise<Void> {
        let coordinate3D = DCKCoordinate3D(latitude: coordinate.latitude, longitude: coordinate.longitude, altitude: altitude)
        return fly(to: coordinate3D, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKAltitude, atSpeed speed: DCKVelocity) -> Promise<Void> {
        let coordinate3D = DCKCoordinate3D(latitude: coordinate.latitude, longitude: coordinate.longitude, altitude: altitude)
        return fly(to: coordinate3D, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atAltitude: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKAltitude) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atAltitude: altitude)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atSpeed speed: DCKVelocity) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atAltitude: nil, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKAltitude, atSpeed speed: DCKVelocity) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atAltitude: altitude, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate3D) -> Promise<Void> {
        return fly(to: coordinate, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate3D) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate3D, atSpeed speed: DCKVelocity) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atSpeed: speed)
    }
}

// MARK: Return home variants

public extension DroneToken {
    final func returnHome() -> Promise<Void> {
        return returnHome(atAltitude: nil, atSpeed: nil)
    }
    
    final func returnHome(atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return returnHome(atAltitude: nil, atSpeed: speed)
    }
}

// MARK: - DroneTokenError

enum DroneTokenError: Error {
    case TokenAquisitionFailed
    case MandatoryInputAquisitionFailed
    case FailureInFlightTriggersLand
    case FailureDuringLand
    case FailureDuringHover
}
