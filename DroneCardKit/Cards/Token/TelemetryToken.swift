//
//  TelemetryToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 2/17/17.
//  Copyright © 2017 IBM. All rights reserved.
//

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
