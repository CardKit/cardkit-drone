//
//  DummyTelemetryToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 2/17/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKit
import CardKitRuntime

public class DummyTelemetryToken: ExecutableTokenCard, TelemetryToken {
    public var currentLocation: DCKCoordinate2D? {
        // make up a random location
        let randomLat = Double(Int(arc4random_uniform(UInt32(360))) - 180)
        let randomLong = Double(Int(arc4random_uniform(UInt32(360))) - 180)
        return DCKCoordinate2D(latitude: randomLat, longitude: randomLong)
    }
    
    public var currentAltitude: DCKRelativeAltitude? {
        // make up a random altitude
        let randomAlt = Double(arc4random_uniform(UInt32(400)))
        return DCKRelativeAltitude(metersAboveGroundAtTakeoff: randomAlt)
    }
    
    public var currentAttitude: DCKAttitude? {
        // make up a random attitude
        let randomYaw = Double(arc4random_uniform(UInt32(360)))
        let randomPitch = Double(arc4random_uniform(UInt32(360)))
        let randomRoll = Double(arc4random_uniform(UInt32(360)))
        return DCKAttitude(yaw: DCKAngle(degrees: randomYaw), pitch: DCKAngle(degrees: randomPitch), roll: DCKAngle(degrees: randomRoll))
    }
    
    public var areMotorsOn: Bool? {
        // return a random answer
        let coinFlip = arc4random_uniform(2)
        return coinFlip == 0
    }
}
