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
    var currentLocation: DCKCoordinate2D? { get }
    var currentAltitude: DCKRelativeAltitude? { get }
    var currentAttitude: DCKAttitude? { get }
    
    // Motor state
    var areMotorsOn: Bool? { get }
    func turnMotorsOn() -> Promise<Void>
    func turnMotorsOff() -> Promise<Void>
    
    // Take off
    func takeOff(at altitude: DCKRelativeAltitude?) -> Promise<Void>
    
    // Hover
    func hover(at altitude: DCKRelativeAltitude?, withYaw yaw: DCKAngle?) -> Promise<Void>
    
    // Fly
    func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) -> Promise<Void>
    func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) -> Promise<Void>
    func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKSpeed?) -> Promise<Void>
    
    // Return home
    var homeLocation: DCKCoordinate2D? { get }
    func returnHome(atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) -> Promise<Void>
    
    // Landing gear
    var isLandingGearDown: Bool? { get }
    func landingGear(down: Bool) -> Promise<Void>
    
    // Land
    func land() -> Promise<Void>
}

// MARK: Fly convenience methods

public extension DroneToken {
    func takeOff() -> Promise<Void> {
        return takeOff(at: nil)
    }
    
    func hover() -> Promise<Void> {
        return hover(at: nil, withYaw: nil)
    }
    
    func hover(at altitude: DCKRelativeAltitude?) -> Promise<Void> {
        return hover(at: altitude, withYaw: nil)
    }
    
    func hover(withYaw yaw: DCKAngle?) -> Promise<Void> {
        return hover(at: nil, withYaw: yaw)
    }
}

// DCKCoordinate2D
public extension DroneToken {
    final func fly(to coordinate: DCKCoordinate2D) -> Promise<Void> {
        return fly(to: coordinate, atYaw: nil, atAltitude: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?) -> Promise<Void> {
        return fly(to: coordinate, atYaw: yaw, atAltitude: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?) -> Promise<Void> {
        return fly(to: coordinate, atYaw: nil, atAltitude: altitude, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atSpeed speed: DCKSpeed?) -> Promise<Void> {
        return fly(to: coordinate, atYaw: nil, atAltitude: nil, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?) -> Promise<Void> {
        return fly(to: coordinate, atYaw: yaw, atAltitude: altitude, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atSpeed speed: DCKSpeed?) -> Promise<Void> {
        return fly(to: coordinate, atYaw: yaw, atAltitude: nil, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) -> Promise<Void> {
        return fly(to: coordinate, atYaw: nil, atAltitude: altitude, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) -> Promise<Void> {
        return fly(to: coordinate, atYaw: yaw, atAltitude: altitude, atSpeed: speed)
    }
}

// DCKOrientedCoordiante2D
public extension DroneToken {
    final func fly(to coordinate: DCKOrientedCoordinate2D) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude?) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atSpeed speed: DCKSpeed?) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: nil, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude, atSpeed: speed)
    }
}

// DCKCoordiante3D
public extension DroneToken {
    final func fly(to coordinate: DCKCoordinate3D) -> Promise<Void> {
        return fly(to: coordinate, atYaw: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate3D, atYaw yaw: DCKAngle?, atSpeed speed: DCKSpeed?) -> Promise<Void> {
        let coordinate2D = DCKCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return fly(to: coordinate2D, atYaw: yaw, atAltitude: coordinate.altitude, atSpeed: speed)
    }
}

// DCKOrientedCoordinate3D
public extension DroneToken {
    final func fly(to coordinate: DCKOrientedCoordinate3D) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate3D, atSpeed speed: DCKSpeed?) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atSpeed: speed)
    }
}

// MARK: Return home variants

public extension DroneToken {
    final func returnHome() -> Promise<Void> {
        return returnHome(atAltitude: nil, atSpeed: nil)
    }
    
    final func returnHome(atSpeed speed: DCKSpeed?) -> Promise<Void> {
        return returnHome(atAltitude: nil, atSpeed: speed)
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
