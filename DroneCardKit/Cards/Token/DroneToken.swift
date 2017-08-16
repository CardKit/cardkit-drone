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
    /// Turn on (or off) the drone's motors.
    func spinMotors(on: Bool) throws
    
    /// Commands the drone to take off. If the drone is already in the air, this function should not do anything.
    func takeOff(at altitude: DCKRelativeAltitude?) throws
    
    /// Causes the drone to hover in its current location. The drone will fly to an altitude (if specified) and change its yaw (if specified).
    func hover(at altitude: DCKRelativeAltitude?, withYaw yaw: DCKAngle?) throws
    
    /// Fly to the given coordinate at an altitude, speed, and yaw.
    func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) throws
    
    /// Fly along the given 2D path, at the given altitude and speed.
    func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) throws
    
    /// Fly along the given 3D path, at the given speed.
    func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKSpeed?) throws
    
    /// Fly in a circle around the center point.
    func circle(around center: DCKCoordinate2D, atRadius radius: DCKDistance, atAltitude altitude: DCKRelativeAltitude, atAngularVelocity angularVelocity: DCKAngularVelocity?, direction: DCKRotationDirection?, repeatedly shouldRepeat: Bool) throws
    
    /// Home location (captured at takeoff)
    var homeLocation: DCKCoordinate2D? { get }
    
    /// Causes the drone to return home.
    func returnHome(atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, toLand land: Bool) throws
    
    /// Causes the drone to spin around at the given angular velocity.
    func spinAround(toYawAngle yaw: DCKAngle, atAngularVelocity angularVelocity: DCKAngularVelocity?) throws
    
    /// Returns true if the landing gear is down, false otherwise.
    var isLandingGearDown: Bool? { get }
    
    /// Changes the state of the landing gear.
    func landingGear(down: Bool) throws
    
    /// Lands the drone at the current location. Once the drone has landed, the motors should automatically disengage.
    func land() throws
}

public extension DroneToken {
    func takeOff(at altitude: DCKRelativeAltitude? = nil) throws {
        try self.takeOff(at: nil)
    }
    
    func hover(at altitude: DCKRelativeAltitude? = nil, withYaw yaw: DCKAngle? = nil) throws {
        try self.hover(at: altitude, withYaw: nil)
    }
    
    func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle? = nil, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try self.fly(to: coordinate, atYaw: yaw, atAltitude: altitude, atSpeed: speed)
    }
    
    func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try self.fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude, atSpeed: speed)
    }
    
    func fly(to coordinate: DCKCoordinate3D, atYaw yaw: DCKAngle? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try self.fly(to: coordinate.as2D(), atYaw: yaw, atAltitude: coordinate.altitude, atSpeed: speed)
    }
    
    func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try self.fly(on: path, atAltitude: altitude, atSpeed: speed)
    }
}

// MARK: - DroneTokenError

public enum DroneTokenError: Error {
    case failureInFlightTriggersLand
    case failureDuringLand
    case failureDuringHover
    case failureRetrievingDroneState
}
