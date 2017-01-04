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

public typealias DroneTokenCompletionHandler = (Error?) -> Void

// MARK: Protocol methods to be implemented
public protocol DroneToken {
    // Location & attitude
    var currentLocation: DCKCoordinate2D? { get }
    var currentAltitude: DCKRelativeAltitude? { get }
    var currentAttitude: DCKAttitude? { get }
    
    // Motor state
    var areMotorsOn: Bool? { get }
    func spinMotors(on: Bool, completionHandler: DroneTokenCompletionHandler?)
    
    // Take off
    func takeOff(at altitude: DCKRelativeAltitude?, completionHandler: DroneTokenCompletionHandler?)
    
    // Hover
    func hover(at altitude: DCKRelativeAltitude?, withYaw yaw: DCKAngle?, completionHandler: DroneTokenCompletionHandler?)
    
    // Fly
    func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?)
    func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?)
    func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?)
    
    // Return home
    var homeLocation: DCKCoordinate2D? { get }
    func returnHome(atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?)
    
    // Landing gear
    var isLandingGearDown: Bool? { get }
    func landingGear(down: Bool, completionHandler: DroneTokenCompletionHandler?)
    
    // Land
    func land(completionHandler: DroneTokenCompletionHandler?)
}

// MARK: Convienience -- turn motors on/off
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

// MARK: Convienience -- take off
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


// MARK: Convienience -- hover
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

// MARK: Convienience -- fly to coordinate
public extension DroneToken {
    final func flySync(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) throws {
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
    
    final func fly(to coordinate: DCKCoordinate2D, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate, atYaw: nil, atAltitude: nil, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate2D) throws {
        try flySync(to: coordinate, atYaw: nil, atAltitude: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate, atYaw: yaw, atAltitude: nil, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, completionHandler: DroneTokenCompletionHandler?) throws {
        try flySync(to: coordinate, atYaw: yaw, atAltitude: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate, atYaw: nil, atAltitude: altitude, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?) throws {
        try flySync(to: coordinate, atYaw: nil, atAltitude: altitude, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate, atYaw: nil, atAltitude: nil, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate2D, atSpeed speed: DCKSpeed?) throws {
        try flySync(to: coordinate, atYaw: nil, atAltitude: nil, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate, atYaw: yaw, atAltitude: altitude, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?) throws {
        try flySync(to: coordinate, atYaw: yaw, atAltitude: altitude, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate, atYaw: yaw, atAltitude: nil, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atSpeed speed: DCKSpeed?) throws {
        try flySync(to: coordinate, atYaw: yaw, atAltitude: nil, atSpeed: speed)
    }

    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate, atYaw: nil, atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) throws {
        try flySync(to: coordinate, atYaw: nil, atAltitude: altitude, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: nil, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKOrientedCoordinate2D) throws {
        try flySync(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude?) throws {
        try flySync(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: nil, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKOrientedCoordinate2D, atSpeed speed: DCKSpeed?) throws {
        try flySync(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: nil, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) throws {
        try flySync(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate3D, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate.as2D(), atYaw: nil, atAltitude: coordinate.altitude, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate3D) throws {
        try flySync(to: coordinate.as2D(), atYaw: nil, atAltitude: coordinate.altitude, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate3D, atYaw yaw: DCKAngle?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        fly(to: coordinate.as2D(), atYaw: yaw, atAltitude: coordinate.altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func flySync(to coordinate: DCKCoordinate3D, atYaw yaw: DCKAngle?, atSpeed speed: DCKSpeed?) throws {
        try flySync(to: coordinate.as2D(), atYaw: yaw, atAltitude: coordinate.altitude, atSpeed: speed)
    }
}

// MARK: Convienience -- fly 2D path
public extension DroneToken {
    final func flySync(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) throws {
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
    
    final func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude?, completionHandler: DroneTokenCompletionHandler?) {
        fly(on: path, atAltitude: altitude, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func flySync(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude?) throws {
        try flySync(on: path, atAltitude: altitude, atSpeed: nil)
    }
    
    final func fly(on path: DCKCoordinate2DPath, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        fly(on: path, atAltitude: nil, atSpeed: speed, completionHandler: completionHandler)
    }

    final func flySync(on path: DCKCoordinate2DPath, atSpeed speed: DCKSpeed?) throws {
        try flySync(on: path, atAltitude: nil, atSpeed: speed)
    }
}

// MARK: Convienience -- fly 3D path
public extension DroneToken {
    final func flySync(on path: DCKCoordinate3DPath, atSpeed speed: DCKSpeed?) throws {
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
    
    final func fly(on path: DCKCoordinate3DPath, completionHandler: DroneTokenCompletionHandler?) {
        fly(on: path, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func flySync(on path: DCKCoordinate3DPath, atAltitude altitude: DCKRelativeAltitude?) throws {
        try flySync(on: path, atSpeed: nil)
    }
}


// MARK: Convienience -- return home
public extension DroneToken {
    final func returnHomeSync(atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) throws {
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
    
    final func returnHome(completionHandler: DroneTokenCompletionHandler?) {
        returnHome(atAltitude: nil, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func returnHomeSync() throws {
        try returnHomeSync(atAltitude: nil, atSpeed: nil)
    }
    
    final func returnHome(atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        returnHome(atAltitude: nil, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func returnHomeSync(atSpeed speed: DCKSpeed?) throws {
        try returnHomeSync(atAltitude: nil, atSpeed: speed)
    }
}

// MARK: Convienience -- landing gear
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

// MARK: Convienience -- land
public extension DroneToken {
    final func landSync() throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        land() { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
}

// MARK: - DroneTokenError
public enum DroneTokenError: Error {
    case TokenAquisitionFailed
    case MandatoryInputAquisitionFailed
    case FailureInFlightTriggersLand
    case FailureDuringLand
    case FailureDuringHover
    case FailureRetrievingDroneState
}
