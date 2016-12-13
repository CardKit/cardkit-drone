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
    func motors(spinning: Bool) -> Promise<Void>
    
    func currentLocation() -> Promise<DCKCoordinate3D>
    func currentOrientation() -> Promise<DCKOrientation>
    
    func hover(withYaw yaw: DCKAngle?) -> Promise<Void>
    
    func fly(to altitude: DCKRelativeAltitude, withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void>
    func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void>
    func fly(on path: DCKCoordinate2DPath, atSpeed speed: DCKVelocity?) -> Promise<Void>
    func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKVelocity?) -> Promise<Void>
    
    func setHome(location: DCKCoordinate2D)
    func homeLocation() -> Promise<DCKCoordinate2D>
    func returnHome(withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void>
    
    func landingGear(down: Bool) -> Promise<Void>
    
    func land() -> Promise<Void>
}

public extension DroneToken {
    
    final func fly(to altitude: DCKRelativeAltitude) -> Promise<Void> {
        return fly(to: altitude, withYaw: nil, atSpeed: nil)
    }
    
    final func fly(to altitude: DCKRelativeAltitude, withYaw yaw: DCKAngle?) -> Promise<Void> {
        return fly(to: altitude, withYaw: yaw, atSpeed: nil)
    }
    
    final func fly(to altitude: DCKRelativeAltitude, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return fly(to: altitude, withYaw: nil, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate2D) -> Promise<Void> {
        return fly(to: coordinate, atAltitude: nil, withYaw: nil, atSpeed: nil)
    }
   
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?) -> Promise<Void> {
        return fly(to: coordinate, atAltitude: altitude, withYaw: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, withYaw yaw: DCKAngle?) -> Promise<Void> {
        return fly(to: coordinate, atAltitude: altitude, withYaw: yaw, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return fly(to: coordinate, atAltitude: altitude, withYaw: nil, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, withYaw yaw: DCKAngle?) -> Promise<Void> {
        return fly(to: coordinate, atAltitude: nil, withYaw: yaw, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return fly(to: coordinate, atAltitude: nil, withYaw: yaw, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return fly(to: coordinate, atAltitude: nil, withYaw: nil, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atAltitude: nil, withYaw: coordinate.yaw, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude?) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atAltitude: altitude, withYaw: coordinate.yaw, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atAltitude: nil, withYaw: coordinate.yaw, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return fly(to: coordinate.asNonOriented(), atAltitude: altitude, withYaw: coordinate.yaw, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate3D) -> Promise<Void> {
        return fly(to: coordinate.as2D(), atAltitude: coordinate.altitude, withYaw: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate3D, withYaw yaw: DCKAngle?) -> Promise<Void> {
        return fly(to: coordinate.as2D(), atAltitude: coordinate.altitude, withYaw: yaw, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate3D, withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return fly(to: coordinate.as2D(), atAltitude: coordinate.altitude, withYaw: yaw, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate3D, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return fly(to: coordinate.as2D(), atAltitude: coordinate.altitude, withYaw: nil, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate3D, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return fly(to: coordinate.as2D().asNonOriented(), atAltitude: coordinate.altitude, withYaw: coordinate.orientation.yaw, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKOrientedCoordinate3D) -> Promise<Void> {
        return fly(to: coordinate.as2D().asNonOriented(), atAltitude: coordinate.altitude, withYaw: coordinate.orientation.yaw, atSpeed: nil)
    }
    
    final func returnHome(withYaw yaw: DCKAngle?) -> Promise<Void> {
        return returnHome(withYaw: yaw, atSpeed: nil)
    }
    
    final func returnHome(atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return returnHome(withYaw: nil, atSpeed: speed)
    }

}

public enum DroneTokenError: Error {
    case TokenAquisitionFailed
    case MandatoryInputAquisitionFailed
    case FailureInFlightTriggersLand
    case FailureDuringLand
    case FailureDuringHover
    case FailureRetrievingState
}
