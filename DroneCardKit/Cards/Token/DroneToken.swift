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

public typealias DroneTokenCompletionHandler = (Error?) -> Void

public protocol DroneToken {
    // MARK: Location & attitude
    var currentLocation: DCKCoordinate2D? { get }
    var currentAltitude: DCKRelativeAltitude? { get }
    var currentAttitude: DCKAttitude? { get }
    
    // MARK: Motor state
    var areMotorsOn: Bool? { get }
    func spinMotors(on: Bool, completionHandler: DroneTokenCompletionHandler?)
    
    // MARK: Take off
    
    /// Takes off to a default altitude or custom altitude (if specified).
    /// If the drone is already in the air, this function should not do anything.
    ///
    /// - Parameters:
    ///   - altitude: the altitude the drone will climb to. if nil, the drone will take off to it's default take off altitude.
    ///   - completionHandler: DroneTokenCompletionHandler
    func takeOff(at altitude: DCKRelativeAltitude?, completionHandler: DroneTokenCompletionHandler?)
    
    // MARK: Hover
    
    /// Cancels all current operations and hovers. The drone will fly to an altitude (if specified) and change its yaw (if specified).
    ///
    /// - Parameters:
    ///   - altitude: the height the drone should be at. if nil, the altitude will not change.
    ///   - yaw: the angle the drone should be facing. if nil, the yaw will not change.
    ///   - completionHandler: DroneTokenCompletionHandler
    func hover(at altitude: DCKRelativeAltitude?, withYaw yaw: DCKAngle?, completionHandler: DroneTokenCompletionHandler?)
    
    // MARK: Fly
    
    /// Fly to a coordinate at an altitude, speed, and yaw. The drone will change its yaw angle and then fly to the location.
    /// The yaw angle will be updated by calling the hover(withYaw:) function.
    ///
    /// - Parameters:
    ///   - coordinate: the location the drone needs to fly to
    ///   - yaw: the angle the drone should be facing. if nil, the yaw will not change.
    ///   - altitude: the height the drone should be at. if nil, the altitude will not change.
    ///   - speed: the speed the drone should be flying. if nil, the default speed will be used (8 m/s)
    ///   - completionHandler: DroneTokenCompletionHandler
    func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?)
    func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?)
    func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?)
    
    // MARK: Return home
    var homeLocation: DCKCoordinate2D? { get }
    func returnHome(atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?)
    
    // MARK: Landing gear
    var isLandingGearDown: Bool? { get }
    func landingGear(down: Bool, completionHandler: DroneTokenCompletionHandler?)
    
    // MARK: Land
    
    /// Lands the drone at the current location. Once the drone has landed, the motors will automatically turn off.
    ///
    /// - Parameter completionHandler: DroneTokenCompletionHandler
    func land(completionHandler: DroneTokenCompletionHandler?)
}

// MARK: - Convienience -- turn motors on/off
public extension DroneToken {
    final func spinMotorsSync(on: Bool) throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        spinMotors(on: on) { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
}

// MARK: - Convienience -- take off
public extension DroneToken {
    func takeOffSync(at altitude: DCKRelativeAltitude?) throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        takeOff(at: altitude) { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
    
    func takeOff(completionHandler: DroneTokenCompletionHandler?) {
        return takeOff(at: nil, completionHandler: completionHandler)
    }
    
    func takeOffSync() throws {
        return try takeOffSync(at: nil)
    }
}


// MARK: - Convienience -- hover
public extension DroneToken {
    final func hoverSync(at altitude: DCKRelativeAltitude?, withYaw yaw: DCKAngle?) throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        hover(at: altitude, withYaw: yaw) { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
    
    final func hover(completionHandler: DroneTokenCompletionHandler?) {
        hover(at: nil, withYaw: nil, completionHandler: completionHandler)
    }
    
    final func hoverSync() throws {
        try hoverSync(at: nil, withYaw: nil)
    }
    
    final func hover(at altitude: DCKRelativeAltitude?, completionHandler: DroneTokenCompletionHandler?) {
        hover(at: altitude, withYaw: nil, completionHandler: completionHandler)
    }
    
    final func hoverSync(at altitude: DCKRelativeAltitude?) throws {
        try hoverSync(at: altitude, withYaw: nil)
    }
    
    final func hover(withYaw yaw: DCKAngle?, completionHandler: DroneTokenCompletionHandler?) {
        hover(at: nil, withYaw: yaw, completionHandler: completionHandler)
    }
    
    final func hoverSync(withYaw yaw: DCKAngle?) throws {
        try hoverSync(at: nil, withYaw: yaw)
    }
}

// MARK: - Convienience -- fly to coordinate
public extension DroneToken {
    
    //fly to with DCKCoordinate2D
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle? = nil, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil, completionHandler: DroneTokenCompletionHandler? = nil) {
        fly(to: coordinate, atYaw: yaw, atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle? = nil, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        fly(to: coordinate, atYaw: yaw, atAltitude: altitude, atSpeed: speed) { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
    
    //fly to with DCKOrientedCoordinate2D
    final func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil, completionHandler: DroneTokenCompletionHandler? = nil) {
        fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try flySync(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude, atSpeed: speed)
    }
    
    //fly to with DCKCoordinate3D
    final func fly(to coordinate: DCKCoordinate3D, atYaw yaw: DCKAngle? = nil, atSpeed speed: DCKSpeed? = nil, completionHandler: DroneTokenCompletionHandler? = nil) {
        fly(to: coordinate.as2D(), atYaw: yaw, atAltitude: coordinate.altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate3D, atYaw yaw: DCKAngle? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        try flySync(to: coordinate.as2D(), atYaw: yaw, atAltitude: coordinate.altitude, atSpeed: speed)
    }
}

// MARK: - Convienience -- fly 2D path
public extension DroneToken {
    final func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil, completionHandler: DroneTokenCompletionHandler? = nil) {
        fly(on: path, atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        fly(on: path, atAltitude: altitude, atSpeed: speed) { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
}

// MARK: - Convienience -- fly 3D path
public extension DroneToken {
    final func fly(on path: DCKCoordinate3DPath,  atSpeed speed: DCKSpeed? = nil, completionHandler: DroneTokenCompletionHandler? = nil) {
        fly(on: path, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(on path: DCKCoordinate3DPath, atSpeed speed: DCKSpeed? = nil) throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        fly(on: path, atSpeed: speed) { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
}


// MARK: - Convienience -- return home
public extension DroneToken {
    final func returnHome(atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil, completionHandler: DroneTokenCompletionHandler? = nil) {
        returnHome(atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func returnHomeSync(atAltitude altitude: DCKRelativeAltitude? = nil, atSpeed speed: DCKSpeed? = nil) throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        returnHome(atAltitude: altitude, atSpeed: speed) { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
}

// MARK: - Convienience -- landing gear
public extension DroneToken {
    final func landingGearSync(down: Bool) throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        landingGear(down: down) { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
}

// MARK: - Convienience -- land
public extension DroneToken {
    final func landSync() throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        land { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
}

// MARK: - - DroneTokenError
public enum DroneTokenError: Error {
    case TokenAquisitionFailed
    case MandatoryInputAquisitionFailed
    case FailureInFlightTriggersLand
    case FailureDuringLand
    case FailureDuringHover
    case FailureRetrievingDroneState
}
