//
//  DummyGimbalToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 3/2/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKit
import CardKitRuntime

public class DummyGimbalToken: BaseMockToken, GimbalToken {
    public var currentAttitude: DCKAttitude? {
        return self.attitude
    }
    
    private var attitude: DCKAttitude = DCKAttitude.zero
    
    override public init(with card: TokenCard) {
        super.init(with: card)
    }
    
    public func calibrate() throws {
        self.registerFunctionCall(named: "calibrate")
    }
    
    public func reset() throws {
        self.registerFunctionCall(named: "reset")
        self.attitude = DCKAttitude.zero
    }
    
    public func rotate(yaw: DCKAngle?, pitch: DCKAngle?, roll: DCKAngle?, relativeToDrone: Bool, withinTimeInSeconds duration: Double?) throws {
        self.registerFunctionCall(named: "rotate")
        self.attitude = DCKAttitude(yaw: yaw ?? self.attitude.yaw, pitch: pitch ?? self.attitude.pitch, roll: roll ?? self.attitude.roll)
    }
    
    public func rotate(yaw: DCKAngularVelocity?, pitch: DCKAngularVelocity?, roll: DCKAngularVelocity?, forTimeInSeconds duration: Double) throws {
        self.registerFunctionCall(named: "rotate")
        
        var newYaw: DCKAngle? = nil
        if let yaw = yaw {
            newYaw = self.attitude.yaw + DCKAngle(degrees: (yaw.degreesPerSecond * duration))
        }
        
        var newPitch: DCKAngle? = nil
        if let pitch = pitch {
            newPitch = self.attitude.pitch + DCKAngle(degrees: (pitch.degreesPerSecond * duration))
        }
        
        var newRoll: DCKAngle? = nil
        if let roll = roll {
            newRoll = self.attitude.roll + DCKAngle(degrees: (roll.degreesPerSecond * duration))
        }
        
        self.attitude = DCKAttitude(yaw: newYaw ?? self.attitude.yaw, pitch: newPitch ?? self.attitude.pitch, roll: newRoll ?? self.attitude.roll)
    }
    
    public func orient(to position: GimbalOrientation) throws {
        self.registerFunctionCall(named: "orient")
        
        switch position {
        case .facingDownward:
            self.attitude = DCKAttitude(yaw: DCKAngle(degrees: 0), pitch: DCKAngle(degrees: 90), roll: DCKAngle(degrees: 0))
        case .facingForward:
            self.attitude = DCKAttitude.zero
        }
    }
}
