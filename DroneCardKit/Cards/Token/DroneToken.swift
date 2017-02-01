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

// swiftlint:disable variable_name

public protocol DroneToken {
    // MARK: Location & attitude
    var currentLocation: DCKCoordinate2D? { get }
    var currentAltitude: DCKRelativeAltitude? { get }
    var currentAttitude: DCKAttitude? { get }
    
    // MARK: Motor state
    var areMotorsOn: Bool? { get }
    func spinMotors(on: Bool, completionHandler: AsyncExecutionCompletionHandler?)
    
    // MARK: Take off
    
    /// Takes off to a default altitude or custom altitude (if specified).
    /// If the drone is already in the air, this function should not do anything.
    ///
    /// - Parameters:
    ///   - altitude: the altitude the drone will climb to. if nil, the drone will take off to it's default take off altitude.
    ///   - completionHandler: AsyncExecutionCompletionHandler
    func takeOff(at altitude: DCKRelativeAltitude?, completionHandler: AsyncExecutionCompletionHandler?)
    
    // MARK: Hover
    
    /// Cancels all current operations and hovers. The drone will fly to an altitude (if specified) and change its yaw (if specified).
    ///
    /// - Parameters:
    ///   - altitude: the height the drone should be at. if nil, the altitude will not change.
    ///   - yaw: the angle the drone should be facing. if nil, the yaw will not change.
    ///   - completionHandler: AsyncExecutionCompletionHandler
    func hover(at altitude: DCKRelativeAltitude?, withYaw yaw: DCKAngle?, completionHandler: AsyncExecutionCompletionHandler?)
    
    // MARK: Fly
    
    /// Fly to a coordinate at an altitude, speed, and yaw. The drone will change its yaw angle and then fly to the location.
    /// The yaw angle will be updated by calling the hover(withYaw:) function.
    ///
    /// - Parameters:
    ///   - coordinate: the location the drone needs to fly to
    ///   - yaw: the angle the drone should be facing. if nil, the yaw will not change.
    ///   - altitude: the height the drone should be at. if nil, the altitude will not change.
    ///   - speed: the speed the drone should be flying. if nil, the default speed will be used (8 m/s)
    ///   - completionHandler: AsyncExecutionCompletionHandler
    func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: AsyncExecutionCompletionHandler?)
    func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: AsyncExecutionCompletionHandler?)
    func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKSpeed?, completionHandler: AsyncExecutionCompletionHandler?)
    
    // MARK: Return home
    var homeLocation: DCKCoordinate2D? { get }
    func returnHome(atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: AsyncExecutionCompletionHandler?)
    
    // MARK: Landing gear
    var isLandingGearDown: Bool? { get }
    func landingGear(down: Bool, completionHandler: AsyncExecutionCompletionHandler?)
    
    // MARK: Land
    
    /// Lands the drone at the current location. Once the drone has landed, the motors will automatically turn off.
    ///
    /// - Parameter completionHandler: AsyncExecutionCompletionHandler
    func land(completionHandler: AsyncExecutionCompletionHandler?)
}

// MARK: - Convienience -- turn motors on/off
public extension DroneToken {
    final func spinMotors(on: Bool, completionHandler: AsyncExecutionCompletionHandler? = nil) {
        spinMotors(on: on, completionHandler: completionHandler)
    }
    
    final func spinMotorsSync(on: Bool) throws {
        try DispatchQueue.executeSynchronously { self.spinMotors(on: on, completionHandler: $0) }
    }
}

// MARK: - Convienience -- take off
public extension DroneToken {
    final func takeOff(at altitude: DCKRelativeAltitude? = nil, completionHandler: AsyncExecutionCompletionHandler? = nil) {
        return takeOff(at: nil, completionHandler: completionHandler)
    }
    
    final func takeOffSync(at altitude: DCKRelativeAltitude? = nil) throws {
        try DispatchQueue.executeSynchronously { self.takeOff(at: altitude, completionHandler: $0) }
    }
}


// MARK: - Convienience -- hover
public extension DroneToken {
    final func hover(at altitude: DCKRelativeAltitude? = nil, withYaw yaw: DCKAngle? = nil, completionHandler: AsyncExecutionCompletionHandler?) {
        hover(at: altitude, withYaw: nil, completionHandler: completionHandler)
    }
    
    final func hoverSync(at altitude: DCKRelativeAltitude? = nil, withYaw yaw: DCKAngle? = nil) throws {
        try DispatchQueue.executeSynchronously { self.hover(at: altitude, completionHandler: $0) }
    }
}

// MARK: - Convienience -- fly to coordinate
public extension DroneToken {
    
    //fly to with DCKCoordinate2D
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle? = nil, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil, completionHandler: AsyncExecutionCompletionHandler? = nil) {
        fly(to: coordinate, atYaw: yaw, atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle? = nil, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try DispatchQueue.executeSynchronously { self.fly(to: coordinate, atYaw: yaw, atAltitude: altitude, atSpeed: speed, completionHandler: $0) }
    }
    
    //fly to with DCKOrientedCoordinate2D
    final func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil, completionHandler: AsyncExecutionCompletionHandler? = nil) {
        fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try flySync(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude, atSpeed: speed)
    }
    
    //fly to with DCKCoordinate3D
    final func fly(to coordinate: DCKCoordinate3D, atYaw yaw: DCKAngle? = nil, atSpeed speed: DCKSpeed? = nil, completionHandler: AsyncExecutionCompletionHandler? = nil) {
        fly(to: coordinate.as2D(), atYaw: yaw, atAltitude: coordinate.altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate3D, atYaw yaw: DCKAngle? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try flySync(to: coordinate.as2D(), atYaw: yaw, atAltitude: coordinate.altitude, atSpeed: speed)
    }
}

// MARK: - Convienience -- fly 2D path
public extension DroneToken {
    final func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil, completionHandler: AsyncExecutionCompletionHandler? = nil) {
        fly(on: path, atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try DispatchQueue.executeSynchronously { self.fly(on: path, atAltitude: altitude, atSpeed: speed, completionHandler: $0) }
    }
}

// MARK: - Convienience -- fly 3D path
public extension DroneToken {
    final func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKSpeed? = nil, completionHandler: AsyncExecutionCompletionHandler? = nil) {
        fly(on: path, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(on path: DCKCoordinate3DPath, atSpeed speed: DCKSpeed? = nil) throws {
        try DispatchQueue.executeSynchronously { self.fly(on: path, atSpeed: speed, completionHandler: $0) }
    }
}


// MARK: - Convienience -- return home
public extension DroneToken {
    final func returnHome(atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil, completionHandler: AsyncExecutionCompletionHandler? = nil) {
        returnHome(atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func returnHomeSync(atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try DispatchQueue.executeSynchronously { self.returnHome(atAltitude: altitude, atSpeed: speed, completionHandler: $0) }
    }
}

// MARK: - Convienience -- landing gear
public extension DroneToken {
    final func landingGear(down: Bool, completionHandler: AsyncExecutionCompletionHandler? = nil) {
        landingGear(down: down, completionHandler: completionHandler)
    }
    
    final func landingGearSync(down: Bool) throws {
        try DispatchQueue.executeSynchronously { self.landingGear(down: down, completionHandler: $0) }
    }
}

// MARK: - Convienience -- land
public extension DroneToken {
    final func land(completionHandler: AsyncExecutionCompletionHandler? = nil) {
        land(completionHandler: completionHandler)
    }
    
    final func landSync() throws {
        try DispatchQueue.executeSynchronously { self.land(completionHandler: $0) }
    }
}

// MARK: - DroneTokenError

public enum DroneTokenError: Error {
    case FailureInFlightTriggersLand
    case FailureDuringLand
    case FailureDuringHover
    case FailureRetrievingDroneState
}
