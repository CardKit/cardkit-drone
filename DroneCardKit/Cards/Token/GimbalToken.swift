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
    func reset(completionHandler: DroneTokenCompletionHandler?)
    func rotate(yaw: DCKAngle?, pitch: DCKAngle?, roll: DCKAngle?, relative: Bool, completionHandler: DroneTokenCompletionHandler?)
}

public extension GimbalToken {
    func rotate(yaw: DCKAngle, completionHandler: DroneTokenCompletionHandler?){
        return rotate(yaw: yaw, pitch: nil, roll: nil, relative: false, completionHandler: completionHandler)
    }
    
    func rotate(pitch: DCKAngle, completionHandler: DroneTokenCompletionHandler?){
        return rotate(yaw: nil, pitch: pitch, roll: nil, relative: false, completionHandler: completionHandler)
    }
    
    func rotate(roll: DCKAngle, completionHandler: DroneTokenCompletionHandler?) {
        return rotate(yaw: nil, pitch: nil, roll: roll, relative: false, completionHandler: completionHandler)
    }
    
    func rotate(yaw: DCKAngle, pitch: DCKAngle, completionHandler: DroneTokenCompletionHandler?) {
        return rotate(yaw: yaw, pitch: pitch, roll: nil, relative: false, completionHandler: completionHandler)
    }
    
    func rotate(yaw: DCKAngle, roll: DCKAngle, completionHandler: DroneTokenCompletionHandler?) {
        return rotate(yaw: yaw, pitch: nil, roll: roll, relative: false, completionHandler: completionHandler)
    }
    
    func rotate(pitch: DCKAngle, roll: DCKAngle, completionHandler: DroneTokenCompletionHandler?) {
        return rotate(yaw: nil, pitch: pitch, roll: roll, relative: false, completionHandler: completionHandler)
    }
    
    func rotate(yaw: DCKAngle, pitch: DCKAngle, roll: DCKAngle, completionHandler: DroneTokenCompletionHandler?) {
        return rotate(yaw: yaw, pitch: pitch, roll: roll, relative: false, completionHandler: completionHandler)
    }
    
    func rotate(attitude: DCKAttitude, completionHandler: DroneTokenCompletionHandler?) {
        return rotate(yaw: attitude.yaw, pitch: attitude.pitch, roll: attitude.roll, relative: false, completionHandler: completionHandler)
    }
    
    func rotate(attitude: DCKAttitude, relative: Bool, completionHandler: DroneTokenCompletionHandler?) {
        return rotate(yaw: attitude.yaw, pitch: attitude.pitch, roll: attitude.roll, relative: relative, completionHandler: completionHandler)
    }
}
