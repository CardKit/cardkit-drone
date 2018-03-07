/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

import CardKit
import CardKitRuntime

public class MockGimbalToken: BaseMockToken, GimbalToken {
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
    
    public func rotate(yaw: DCKAngle?, pitch: DCKAngle?, roll: DCKAngle?, relative: Bool, withinTimeInSeconds duration: Double?) throws {
        self.registerFunctionCall(named: "rotate")
        self.attitude = DCKAttitude(yaw: yaw ?? self.attitude.yaw, pitch: pitch ?? self.attitude.pitch, roll: roll ?? self.attitude.roll)
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
