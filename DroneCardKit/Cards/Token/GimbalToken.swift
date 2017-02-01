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
    
    func calibrate(completionHandler: AsyncExecutionCompletionHandler?)
    func reset(completionHandler: AsyncExecutionCompletionHandler?)
    
    //swiftlint:disable function_parameter_count
    /// Rotates the gimbal to a yaw, pitch, and roll in the specified amount of time. 0º always points towards the front of the drone. Values can range from -360 to 360. Value being negative indicates a reverse movement.
    /// Picture this unit circle: https://i.stack.imgur.com/FR229.png perpendicular to the axis of yaw, pitch, or roll. The gimbal will rotate the number of degrees specified in the direction of the unit circle. See below for examples.
    ///
    /// - Parameters:
    ///   - yaw: Rotation along the perpendicular axis. Example: 90º rotation for yaw will rotate the gimbal right by 90º
    ///   - pitch: Rotation along the lateral axis. Example: 90º rotation for pitch will rotate the gimbal down by 90º
    ///   - roll: Rotation along the longitudinal axis. Example: 90º rotation for roll will rotate the gimbal clockwise by 90º
    ///   - relativeToDrone: if true, rotation will be performed relative to current gimbal position. if false, this will be considered as an absolute position.
    ///   - withinTimeInSeconds: the amount of time in which the drone should perform the rotation.
    ///   - completionHandler: get's called upon success or failure
    func rotate(yaw: DCKAngle?, pitch: DCKAngle?, roll: DCKAngle?, relativeToDrone: Bool, withinTimeInSeconds duration: Double?, completionHandler: AsyncExecutionCompletionHandler?)
    func rotate(yaw: DCKAngularVelocity?, pitch: DCKAngularVelocity?, roll: DCKAngularVelocity?, forTimeInSeconds duration: Double, completionHandler: AsyncExecutionCompletionHandler?)
    //swiftlint:enable function_parameter_count
}

// MARK: - Convienience -- reset

public extension GimbalToken {
    func reset(completionHandler: AsyncExecutionCompletionHandler? = nil) {
        self.reset(completionHandler: completionHandler)
    }
    
    func resetSync() throws {
        try DispatchQueue.executeSynchronously { self.reset(completionHandler: $0) }
    }
}

// MARK: - Convienience -- calibrate

public extension GimbalToken {
    func calibrate(completionHandler: AsyncExecutionCompletionHandler? = nil) {
        self.calibrate(completionHandler: completionHandler)
    }
    
    func calibrateSync() throws {
        try DispatchQueue.executeSynchronously { self.calibrate(completionHandler: $0) }
    }
}

// MARK: - Convienience -- rotate with yaw/pitch/roll

public extension GimbalToken {
    func rotate(yaw: DCKAngle? = nil, pitch: DCKAngle? = nil, roll: DCKAngle? = nil, relative: Bool = false, withinTimeInSeconds: Double? = nil, completionHandler: AsyncExecutionCompletionHandler? = nil) {
        self.rotate(yaw: yaw, pitch: pitch, roll: roll, relative: relative, withinTimeInSeconds: withinTimeInSeconds, completionHandler: completionHandler)
    }
    
    public func rotateSync(yaw: DCKAngle? = nil, pitch: DCKAngle? = nil, roll: DCKAngle? = nil, relative: Bool = false, withinTimeInSeconds: Double? = nil) throws {
        try DispatchQueue.executeSynchronously { self.rotate(yaw: yaw, pitch: pitch, roll: roll, relative: relative, withinTimeInSeconds: withinTimeInSeconds, completionHandler: $0) }
    }
}

// MARK: - Convienience -- rotate with angular velocity

public extension GimbalToken {
    func rotate(yaw: DCKAngularVelocity? = nil, pitch: DCKAngularVelocity? = nil, roll: DCKAngularVelocity? = nil, forTimeInSeconds seconds: Double, completionHandler: AsyncExecutionCompletionHandler? = nil) {
        self.rotate(yaw: yaw, pitch: pitch, roll: roll, forTimeInSeconds: seconds, completionHandler: completionHandler)
    }
    
    func rotate(yaw: DCKAngularVelocity? = nil, pitch: DCKAngularVelocity? = nil, roll: DCKAngularVelocity? = nil, forTimeInSeconds seconds: Double) throws {
        try DispatchQueue.executeSynchronously { self.rotate(yaw: yaw, pitch: pitch, roll: roll, forTimeInSeconds: seconds, completionHandler: $0) }
    }
}
