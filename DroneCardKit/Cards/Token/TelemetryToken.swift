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

/// Read-only drone telemetry. Carries home location, current location, altitude, and attitude.
public protocol TelemetryToken {
    // Home location (captured at takeoff)
    var homeLocation: DCKCoordinate2D? { get }
    
    /// Current location
    var currentLocation: DCKCoordinate2D? { get }
    
    /// Current altitude
    var currentAltitude: DCKRelativeAltitude? { get }
    
    /// Current attitude of the aircraft, in the range of [-180, 180]. The attitude can be normalized to [0, 360]
    /// by calling `currentAttitude.normalized()`.
    var currentAttitude: DCKAttitude? { get }
}
