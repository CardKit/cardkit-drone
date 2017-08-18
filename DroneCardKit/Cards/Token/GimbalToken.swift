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
    
    /// Calibrates the gimbal.
    func calibrate() throws
    
    /// Resets the gimbal.
    func reset() throws
    
    /// Rotates the gimbal to a specified yaw, pitch, and roll within the specified amount of time. 0º always points towards the front of the drone. Values can range from 0º to 360º. Negative values indicate a reverse movement.
    ///
    /// - Parameters:
    ///   - yaw: Rotation along the perpendicular (vertical) axis. Example: A 90º yaw rotation for yaw will turn the gimbal to the right by 90º.
    ///   - pitch: Rotation along the lateral (horizontal) axis. Example: A 90º rotation for pitch will point the gimbal downward by 90º.
    ///   - roll: Rotation along the longitudinal axis. Example: A 10º rotation for roll will twist the gimbal camera clockwise by 10º.
    ///   - relative: if true, the angles will be interpreted as relative to the gimbal's current orientation; if false, the angles will be considered absolute angles.
    ///   - withinTimeInSeconds: the amount of time in which the gimbal should perform the rotation.
    func rotate(yaw: DCKAngle?, pitch: DCKAngle?, roll: DCKAngle?, relative: Bool, withinTimeInSeconds duration: Double?) throws
    
    /// Rotate the gimbal to a given position.
    func orient(to position: GimbalOrientation) throws
}

// MARK: - GimbalOrientation

public enum GimbalOrientation {
    case facingForward
    case facingDownward
}

// MARK: - Convienience Functions for Default Parameters

public extension GimbalToken {
    func rotate(yaw: DCKAngle? = nil, pitch: DCKAngle? = nil, roll: DCKAngle? = nil, relativeToDrone: Bool = false, withinTimeInSeconds: Double? = nil) throws {
        try self.rotate(yaw: yaw, pitch: pitch, roll: roll, relativeToDrone: relativeToDrone, withinTimeInSeconds: withinTimeInSeconds)
    }
}

public enum GimbalTokenError: Error {
    case failedToBeginCalibration
}
