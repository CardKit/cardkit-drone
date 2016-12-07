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

public protocol DroneToken {
    func isFlying() -> Promise<Bool>
    
    func takeOff() -> Promise<Void>
    func takeOff(climbingTo altitude: Double) -> Promise<Void>
    func takeOffCancel() -> Promise<Void>
    
    func fly(to coordinate: DCKCoordinate2D, atSpeed speed: Double) -> Promise<Void>
    func fly(to coordinate: DCKCoordinate3D, atSpeed speed: Double) -> Promise<Void>
    func fly(on path: DCKCoordinate2DPath, atSpeed speed: Double) -> Promise<Void>
    func fly(on path: DCKCoordinate3DPath, atSpeed speed: Double) -> Promise<Void>
    
    func setHome(location: DCKCoordinate2D)
    func getHome() -> DCKCoordinate2D
    func returnHome() -> Promise<Void>
    func returnHomeCancel() -> Promise<Void>
    
    func land() -> Promise<Bool>
    func landCancel() -> Promise<Void>
    
    func landingGear(down: Bool) -> Promise<Void>
    
    func location() -> DCKCoordinate2D
}
