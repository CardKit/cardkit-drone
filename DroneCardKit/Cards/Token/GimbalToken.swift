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

import PromiseKit

public protocol GimbalToken {
    func reset() -> Promise<Void>
    func rotate(yaw: DCKAngle?, pitch: DCKAngle?, roll: DCKAngle?, relative: Bool) -> Promise<Void>
}

public extension GimbalToken {
    func rotate(yaw: DCKAngle) -> Promise<Void> {
        return rotate(yaw: yaw, pitch: nil, roll: nil, relative: false)
    }
    
    func rotate(pitch: DCKAngle) -> Promise<Void> {
        return rotate(yaw: nil, pitch: pitch, roll: nil, relative: false)
    }
    
    func rotate(roll: DCKAngle) -> Promise<Void> {
        return rotate(yaw: nil, pitch: nil, roll: roll, relative: false)
    }
    
    func rotate(yaw: DCKAngle, pitch: DCKAngle) -> Promise<Void> {
        return rotate(yaw: yaw, pitch: pitch, roll: nil, relative: false)
    }
    
    func rotate(yaw: DCKAngle, roll: DCKAngle) -> Promise<Void> {
        return rotate(yaw: yaw, pitch: nil, roll: roll, relative: false)
    }
    
    func rotate(pitch: DCKAngle, roll: DCKAngle) -> Promise<Void> {
        return rotate(yaw: nil, pitch: pitch, roll: roll, relative: false)
    }
    
    func rotate(yaw: DCKAngle, pitch: DCKAngle, roll: DCKAngle) -> Promise<Void> {
        return rotate(yaw: yaw, pitch: pitch, roll: roll, relative: false)
    }
    
    func rotate(attitude: DCKAttitude) -> Promise<Void> {
        return rotate(yaw: attitude.yaw, pitch: attitude.pitch, roll: attitude.roll, relative: false)
    }
    
    func rotate(attitude: DCKAttitude, relative: Bool) -> Promise<Void> {
        return rotate(yaw: attitude.yaw, pitch: attitude.pitch, roll: attitude.roll, relative: relative)
    }
}
