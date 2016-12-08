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
    func returnHome(withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void>
    
    func landingGear(down: Bool) -> Promise<Void>
    
    func land() -> Promise<Void>
}

public extension DroneToken {
    
    final func fly(to altitude: DCKAltitude) -> Promise<Void> {
        return fly(to: altitude, withYaw: nil, atSpeed: nil)
    }
    
    final func fly(to altitude: DCKAltitude, withYaw yaw: DCKAngle?) -> Promise<Void> {
        return fly(to: altitude, withYaw: yaw, atSpeed: nil)
    }
    
    final func fly(to altitude: DCKAltitude, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return fly(to: altitude, withYaw: nil, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate2D) -> Promise<Void> {
        return fly(to: coordinate, atAltitude: nil, withYaw: nil, atSpeed: nil)
    }
   
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKAltitude?) -> Promise<Void> {
        return fly(to: coordinate, atAltitude: altitude, withYaw: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKAltitude?, withYaw yaw: DCKAngle?) -> Promise<Void> {
        return fly(to: coordinate, atAltitude: altitude, withYaw: yaw, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKAltitude?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
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
    
    final func fly(to coordinate: DCKCoordinate3D) -> Promise<Void> {
        return fly(to: coordinate.as2D, atAltitude: coordinate.altitude, withYaw: nil, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate3D, withYaw yaw: DCKAngle?) -> Promise<Void> {
        return fly(to: coordinate.as2D, atAltitude: coordinate.altitude, withYaw: yaw, atSpeed: nil)
    }
    
    final func fly(to coordinate: DCKCoordinate3D, withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return fly(to: coordinate.as2D, atAltitude: coordinate.altitude, withYaw: yaw, atSpeed: speed)
    }
    
    final func fly(to coordinate: DCKCoordinate3D, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return fly(to: coordinate.as2D, atAltitude: coordinate.altitude, withYaw: nil, atSpeed: speed)
    }
    
    final func returnHome(withYaw yaw: DCKAngle?) -> Promise<Void> {
        return returnHome(withYaw: yaw, atSpeed: nil)
    }
    
    final func returnHome(atSpeed speed: DCKVelocity?) -> Promise<Void> {
        return returnHome(withYaw: nil, atSpeed: speed)
    }

}

enum DroneTokenError: Error {
    case TokenAquisitionFailed
    case MandatoryInputAquisitionFailed
    case FailureInFlightTriggersLand
    case FailureDuringLand
}

