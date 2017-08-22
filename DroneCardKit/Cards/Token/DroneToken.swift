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

public protocol DroneToken: TelemetryToken {
    /// True if the motors are on, false otherwise.
    var areMotorsOn: Bool { get }
    
    /// True if the drone is flying, false otherwise.
    var isFlying: Bool { get }
    
    /// True if the landing gear is down (i.e. deployed), and false for any other state of the landing gear.
    var isLandingGearDown: Bool { get }
    
    /// Turn on (or off) the drone's motors.
    func spinMotors(on: Bool) throws
    
    /// Commands the drone to take off. If the drone is already in the air, this function should not do anything.
    func takeOff(at altitude: DCKRelativeAltitude?) throws
    
    /// Causes the drone to hover in its current location at the given altitude. If `altitude` is nil, the drone will hover at its current altitude.
    func hover(at altitude: DCKRelativeAltitude?) throws
    
    /// Orients the drone to point in the given direction.
    func orient(to yaw: DCKAngle) throws
    
    /// Fly to the given 2D coordinate.
    func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) throws
    
    /// Fly along the given 2D path.
    func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) throws
    
    /// Fly along the given 3D path.
    func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKSpeed?) throws
    
    /// Fly in a circle once around the center point at the given radius.
    func circle(around center: DCKCoordinate2D, atRadius radius: DCKDistance, atAltitude altitude: DCKRelativeAltitude?, atAngularVelocity angularVelocity: DCKAngularVelocity?) throws
    
    /// Causes the drone to return home.
    func returnHome() throws
    
    /// Changes the state of the landing gear.
    func landingGear(down: Bool) throws
    
    /// Lands the drone at the current location. Once the drone has landed, the motors should automatically disengage.
    func land() throws
}

public extension DroneToken {
    func takeOff() throws {
        try self.takeOff(at: nil)
    }
    
    func fly(to coordinate: DCKCoordinate2D) throws {
        try self.fly(to: coordinate, atAltitude: nil, atSpeed: nil)
    }
    
    func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try self.fly(to: coordinate, atAltitude: altitude, atSpeed: speed)
    }
    
    func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try self.fly(to: coordinate.asNonOriented(), atAltitude: altitude, atSpeed: speed)
    }
    
    func fly(to coordinate: DCKCoordinate3D, atSpeed speed: DCKSpeed? = nil) throws {
        try self.fly(to: coordinate.as2D(), atAltitude: coordinate.altitude, atSpeed: speed)
    }
    
    func fly(on path: DCKCoordinate2DPath) throws {
        try self.fly(on: path, atAltitude: nil, atSpeed: nil)
    }
    
    func fly(on path: DCKCoordinate3DPath) throws {
        try self.fly(on: path, atSpeed: nil)
    }
    
    func circle(around center: DCKCoordinate2D, atRadius radius: DCKDistance) throws {
        try self.circle(around: center, atRadius: radius, atAltitude: nil, atAngularVelocity: nil)
    }
}

// MARK: - DroneTokenError

public enum DroneTokenError: Error {
    case failureInFlightTriggersLand
    case failureDuringLand
    case failureDuringHover
    case failureRetrievingDroneState
}
