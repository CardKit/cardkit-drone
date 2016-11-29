//
//  DroneToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 9/23/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit
import CardKitRuntime

import PromiseKit

protocol DroneToken {
    func takeOff() -> Promise<Void>
    func takeOff(climbingTo altitude: Double) -> Promise<Void>
    
    func fly(to coordinate: DCKCoordinate2D, atSpeed speed: Double) -> Promise<Void>
    func fly(to coordinate: DCKCoordinate3D, atSpeed speed: Double) -> Promise<Void>
    func fly(on path: DCKCoordinate2DPath, atSpeed speed: Double) -> Promise<Void>
    func fly(on path: DCKCoordinate3DPath, atSpeed speed: Double) -> Promise<Void>
    
    func returnHome() -> Promise<Void>
    
    func land() -> Promise<Void>
}
