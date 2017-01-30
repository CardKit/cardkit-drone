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
public protocol GimbalToken {
    var currentAttitude: DCKAttitude? { get }
    
    func calibrate(completionHandler: DroneTokenCompletionHandler?)
    func reset(completionHandler: DroneTokenCompletionHandler?)
    
    //swiftlint:disable:next function_parameter_count
    func rotate(yaw: DCKAngle?, pitch: DCKAngle?, roll: DCKAngle?, relativeToDrone: Bool, withinTimeInSeconds: Double?, completionHandler: DroneTokenCompletionHandler?)
    func rotate(yaw: DCKAngularVelocity?, pitch: DCKAngularVelocity?, roll: DCKAngularVelocity?, forTimeInSeconds: Double, completionHandler: DroneTokenCompletionHandler?)
}

// MARK: - Convienience -- reset
public extension GimbalToken {
    func reset(completionHandler: DroneTokenCompletionHandler? = nil) {
        self.reset(completionHandler: completionHandler)
    }
    
    func resetSync() throws {
        try TokenDispatch.executeSynchronously() { self.reset(completionHandler: $0) }
    }
}

// MARK: - Convienience -- calibrate
public extension GimbalToken {
    func calibrate(completionHandler: DroneTokenCompletionHandler? = nil) {
        self.calibrate(completionHandler: completionHandler)
    }
    
    func calibrateSync() throws {
        try TokenDispatch.executeSynchronously() { self.calibrate(completionHandler: $0) }
    }
}

// MARK: - Convienience -- rotate with yaw/pitch/roll
public extension GimbalToken {
    func rotate(yaw: DCKAngle? = nil, pitch: DCKAngle? = nil, roll: DCKAngle? = nil, relative: Bool = false, withinTimeInSeconds: Double? = nil, completionHandler: DroneTokenCompletionHandler? = nil) {
        self.rotate(yaw: yaw, pitch: pitch, roll: roll, relative: relative, withinTimeInSeconds: withinTimeInSeconds, completionHandler: completionHandler)
    }
    
    public func rotateSync(yaw: DCKAngle? = nil, pitch: DCKAngle? = nil, roll: DCKAngle? = nil, relative: Bool = false, withinTimeInSeconds: Double? = nil) throws {
        try TokenDispatch.executeSynchronously() { self.rotate(yaw: yaw, pitch: pitch, roll: roll, relative: relative, withinTimeInSeconds: withinTimeInSeconds, completionHandler: $0) }
    }
}

// MARK: - Convienience -- rotate with angular velocity
public extension GimbalToken {
    func rotate(yaw: DCKAngularVelocity? = nil, pitch: DCKAngularVelocity? = nil, roll: DCKAngularVelocity? = nil, forTimeInSeconds seconds: Double, completionHandler: DroneTokenCompletionHandler? = nil) {
        self.rotate(yaw: yaw, pitch: pitch, roll: roll, forTimeInSeconds: seconds, completionHandler: completionHandler)
    }
    
    func rotate(yaw: DCKAngularVelocity? = nil, pitch: DCKAngularVelocity? = nil, roll: DCKAngularVelocity? = nil, forTimeInSeconds seconds: Double) throws {
        try TokenDispatch.executeSynchronously() { self.rotate(yaw: yaw, pitch: pitch, roll: roll, forTimeInSeconds: seconds, completionHandler: $0) }
    }
}
