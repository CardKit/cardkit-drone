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
    func rotateToAbsoluteAngle(pitch: Float, roll: Float, yaw: Float) -> Promise<Void>
    func rotateToRelativeAngle(pitch: Float, roll: Float, yaw: Float) -> Promise<Void>
}
