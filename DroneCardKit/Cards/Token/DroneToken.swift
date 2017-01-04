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

public typealias DroneTokenCompletionHandler = (Error?) -> Void

public protocol DroneToken {
    // Location & attitude
    var currentLocation: DCKCoordinate2D? { get }
    var currentAltitude: DCKRelativeAltitude? { get }
    var currentAttitude: DCKAttitude? { get }
    
    // Motor state
    var areMotorsOn: Bool? { get }
    func turnMotorsOn(completionHandler: DroneTokenCompletionHandler?)
    func turnMotorsOff(completionHandler: DroneTokenCompletionHandler?)
    
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

// MARK: Fly convenience methods

public extension DroneToken {
    func takeOff(completionHandler: DroneTokenCompletionHandler?) {
        return takeOff(at: nil, completionHandler: completionHandler)
    }
    
    func hover(completionHandler: DroneTokenCompletionHandler?) {
        return hover(at: nil, withYaw: nil, completionHandler: completionHandler)
    }
    
    func hover(at altitude: DCKRelativeAltitude?, completionHandler: DroneTokenCompletionHandler?) {
        return hover(at: altitude, withYaw: nil, completionHandler: completionHandler)
    }
    
    func hover(withYaw yaw: DCKAngle?, completionHandler: DroneTokenCompletionHandler?) {
        return hover(at: nil, withYaw: yaw, completionHandler: completionHandler)
    }
}

// DCKCoordinate2D
public extension DroneToken {
    final func fly(to coordinate: DCKCoordinate2D, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate, atYaw: nil, atAltitude: nil, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate, atYaw: yaw, atAltitude: nil, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate, atYaw: nil, atAltitude: altitude, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate, atYaw: nil, atAltitude: nil, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate, atYaw: yaw, atAltitude: altitude, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate, atYaw: yaw, atAltitude: nil, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate, atYaw: nil, atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate, atYaw: yaw, atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
}

// DCKOrientedCoordiante2D
public extension DroneToken {
    final func fly(to coordinate: DCKOrientedCoordinate2D, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: nil, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude, completionHandler: completionHandler)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: nil, atSpeed: speed, completionHandler: completionHandler)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atAltitude: altitude, atSpeed: speed, completionHandler: completionHandler)
    }
}

// DCKCoordiante3D
public extension DroneToken {
    final func fly(to coordinate: DCKCoordinate3D, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate, atYaw: nil, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func fly(to coordinate: DCKCoordinate3D, atYaw yaw: DCKAngle?, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        let coordinate2D = DCKCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return fly(to: coordinate2D, atYaw: yaw, atAltitude: coordinate.altitude, atSpeed: speed, completionHandler: completionHandler)
    }
}

// DCKOrientedCoordinate3D
public extension DroneToken {
    final func fly(to coordinate: DCKOrientedCoordinate3D, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate3D, atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        return fly(to: coordinate.asNonOriented(), atYaw: coordinate.yaw, atSpeed: speed, completionHandler: completionHandler)
    }
}

// MARK: Return home variants

public extension DroneToken {
    final func returnHome(completionHandler: DroneTokenCompletionHandler?) {
        return returnHome(atAltitude: nil, atSpeed: nil, completionHandler: completionHandler)
    }
    
    final func returnHome(atSpeed speed: DCKSpeed?, completionHandler: DroneTokenCompletionHandler?) {
        return returnHome(atAltitude: nil, atSpeed: speed, completionHandler: completionHandler)
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
