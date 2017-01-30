//
//  GimbalToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 11/29/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit
import CardKitRuntime

public typealias GimbalTokenCompletionHandler = (Error?) -> Void

public protocol GimbalToken {
    var currentAttitude: DCKAttitude? { get }
    
    func calibrate(completionHandler: GimbalTokenCompletionHandler?)
    func reset(completionHandler: GimbalTokenCompletionHandler?)
    
    //swiftlint:disable:next function_parameter_count
    func rotate(yaw: DCKAngle?, pitch: DCKAngle?, roll: DCKAngle?, relativeToDrone: Bool, withinTimeInSeconds: Double?, completionHandler: GimbalTokenCompletionHandler?)
    func rotate(yaw: DCKAngularVelocity?, pitch: DCKAngularVelocity?, roll: DCKAngularVelocity?, forTimeInSeconds: Double, completionHandler: GimbalTokenCompletionHandler?)
}

// MARK: - Convienience -- reset
public extension GimbalToken {
    func reset(completionHandler: GimbalTokenCompletionHandler? = nil) {
        self.reset(completionHandler: completionHandler)
    }
    
    func resetSync() throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        self.reset { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
}

// MARK: - Convienience -- calibrate
public extension GimbalToken {
    func calibrate(completionHandler: GimbalTokenCompletionHandler? = nil) {
        self.calibrate(completionHandler: completionHandler)
    }
    
    func calibrateSync() throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        self.calibrate { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
}

// MARK: - Convienience -- rotate with yaw/pitch/roll
public extension GimbalToken {
    func rotate(yaw: DCKAngle? = nil, pitch: DCKAngle? = nil, roll: DCKAngle? = nil, relative: Bool = false, withinTimeInSeconds: Double? = nil, completionHandler: GimbalTokenCompletionHandler? = nil) {
        self.rotate(yaw: yaw, pitch: pitch, roll: roll, relative: relative, withinTimeInSeconds: withinTimeInSeconds, completionHandler: completionHandler)
    }
    
    public func rotateSync(yaw: DCKAngle? = nil, pitch: DCKAngle? = nil, roll: DCKAngle? = nil, relative: Bool = false, withinTimeInSeconds: Double? = nil) throws {
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        self.rotate(yaw: yaw, pitch: pitch, roll: roll, relative: relative, withinTimeInSeconds: withinTimeInSeconds) { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
}

// MARK: - Convienience -- rotate with angular velocity
public extension GimbalToken {
    func rotate(yaw: DCKAngularVelocity? = nil, pitch: DCKAngularVelocity? = nil, roll: DCKAngularVelocity? = nil, forTimeInSeconds seconds: Double, completionHandler: GimbalTokenCompletionHandler? = nil) {
        self.rotate(yaw: yaw, pitch: pitch, roll: roll, forTimeInSeconds: seconds, completionHandler: completionHandler)
    }
    
    func rotate(yaw: DCKAngularVelocity? = nil, pitch: DCKAngularVelocity? = nil, roll: DCKAngularVelocity? = nil, forTimeInSeconds seconds: Double) throws {
        
        let semaphore = DispatchSemaphore(value: 0)
        var error: Error? = nil
        
        self.rotate(yaw: yaw, pitch: pitch, roll: roll, forTimeInSeconds: seconds) { tokenError in
            error = tokenError
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if error != nil {
            throw error!
        }
    }
}
