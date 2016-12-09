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
    
    func rotate(yaw: DCKAngle, pitch: DCKAngle) -> Promise<Void> {
        return rotate(yaw: yaw, pitch: pitch, roll: nil, relative: false)
    }
    
    func rotate(yaw: DCKAngle, pitch: DCKAngle, roll: DCKAngle) -> Promise<Void> {
        return rotate(yaw: yaw, pitch: pitch, roll: roll, relative: false)
    }
    
    func rotate(pitch: DCKAngle) -> Promise<Void> {
        return rotate(yaw: nil, pitch: pitch, roll: nil, relative: false)
    }
    
    func rotate(pitch: DCKAngle, roll: DCKAngle) -> Promise<Void> {
        return rotate(yaw: nil, pitch: pitch, roll: roll, relative: false)
    }
    
    func rotate(orientation: DCKOrientation) -> Promise<Void> {
        return rotate(yaw: orientation.yaw, pitch: orientation.pitch, roll: orientation.roll, relative: false)
    }
    
    func rotate(orientation: DCKOrientation, relative: Bool) -> Promise<Void> {
        return rotate(yaw: orientation.yaw, pitch: orientation.pitch, roll: orientation.roll, relative: relative)
    }
    
}
