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

public class MockTelemetryToken: BaseMockToken, TelemetryToken {
    public var homeLocation: DCKCoordinate2D? {
        // make up a random location
        let randomLat = Double(Int(arc4random_uniform(UInt32(360))) - 180)
        let randomLong = Double(Int(arc4random_uniform(UInt32(360))) - 180)
        return DCKCoordinate2D(latitude: randomLat, longitude: randomLong)
    }
    
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
