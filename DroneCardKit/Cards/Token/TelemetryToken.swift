//
//  TelemetryToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 2/17/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

/// Current drone telemetry, read-only. Carries current location, altitude, attitude, and motor state.
public protocol TelemetryToken {
    // MARK: Location & attitude
    var currentLocation: DCKCoordinate2D? { get }
    var currentAltitude: DCKRelativeAltitude? { get }
    
    /// If the values of the pitch, roll, and yaw are 0, the aircraft will be hovering level with a True North heading.
    /// Values range from 0 to 360. 0º represents North, 90º:East, 180º:South, 270º:West, 360º:North
    var currentAttitude: DCKAttitude? { get }
    
    // MARK: Motor state
    var areMotorsOn: Bool? { get }
}
