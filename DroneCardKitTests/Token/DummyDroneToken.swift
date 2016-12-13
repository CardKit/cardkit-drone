//
//  DummyDroneToken.swift
//  DroneCardKit
//
//  Created by ismails on 12/9/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

@testable import CardKit
@testable import CardKitRuntime
@testable import DroneCardKit
@testable import PromiseKit

class DummyDroneToken: ExecutableTokenCard, DroneToken {
    var homeLocation: DCKCoordinate2D?
    
    var currentLocation: DCKCoordinate2D?
    var currentAltitude: DCKAltitude?
    var currentAttitude: DCKAttitude?
    
    var areMotorsOn: Bool?
    var isLandingGearDown: Bool?
    
    var methodCalls: [String] = []
    
    override init(with card: TokenCard) {
        self.homeLocation = DCKCoordinate2D(latitude: 0, longitude: 0)
        self.currentLocation = DCKCoordinate2D(latitude: 0, longitude: 0)
        self.currentAltitude = DCKAltitude(metersAboveSeaLevel: 0)
        self.currentAttitude = DCKAttitude(yaw: DCKAngle(degrees: 0), pitch: DCKAngle(degrees: 0), roll: DCKAngle(degrees: 0))
        self.areMotorsOn = false
        self.isLandingGearDown = true
        
        super.init(with: card)
    }
    
    // MARK: Instance Methods
    
    private func methodCall(named name: String) {
        self.methodCalls.append(name)
    }
    
    // MARK: DroneToken
    
    func motorOnState() -> Promise<Bool> {
        self.methodCall(named: "motorOnState")
        return Promise<Bool>.empty(result: self.areMotorsOn!)
    }
    
    func turnMotorsOn() -> Promise<Void> {
        self.methodCall(named: "turnMotorsOn")
        self.areMotorsOn = true
        return Promise<Void>.empty(result: ())
    }
    
    func turnMotorsOff() -> Promise<Void> {
        self.methodCall(named: "turnMotorsOff")
        self.areMotorsOn = false
        return Promise<Void>.empty(result: ())
    }
    
    func takeOff() -> Promise<Void> {
        self.methodCall(named: "takeOff")
        
        let _ = self.turnMotorsOn()
        let _ = self.landingGear(down: false)
        
        let newAltitude = DCKAltitude(metersAboveSeaLevel: 1)
        self.currentAltitude = newAltitude
        
        return Promise<Void>.empty(result: ())
    }
    
    func hover() -> Promise<Void> {
        self.methodCall(named: "hover")
        
        return Promise<Void>.empty(result: ())
    }
    
    func hover(at altitude: DCKAltitude) -> Promise<Void> {
        self.methodCall(named: "hover:at:")
        
        let newAltitude = DCKAltitude(metersAboveSeaLevel: 1)
        self.currentAltitude = newAltitude
        
        return Promise<Void>.empty(result: ())
    }
    
    func orient(to yaw: DCKAngle) -> Promise<Void> {
        self.methodCall(named: "orient:to:")
        
        let newAttitude = DCKAttitude(yaw: yaw, pitch: self.currentAttitude!.pitch, roll: self.currentAttitude!.roll)
        self.currentAttitude = newAttitude
        return Promise<Void>.empty(result: ())
    }
    
    func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKAltitude?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        self.methodCall(named: "fly:to:atYaw:atAltitude:atSpeed:")
        
        let newYaw: DCKAngle
        if let yaw = yaw {
            newYaw = yaw
        } else {
            newYaw = self.currentAttitude!.yaw
        }
        
        let newCoord = DCKCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.currentLocation = newCoord
        
        if let altitude = altitude {
            self.currentAltitude = altitude
        }
        
        let newAttitude = DCKAttitude(yaw: newYaw, pitch: self.currentAttitude!.pitch, roll: self.currentAttitude!.roll)
        self.currentAttitude = newAttitude
        
        return Promise<Void>.empty(result: ())
    }
    
    func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKAltitude?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        self.methodCall(named: "fly:on:atAltitude:atSpeed:")
        
        var flightPromise: Promise<Void> = firstly {
            return Promise<Void>.empty(result: ())
        }
        
        for coord in path.path {
            flightPromise = flightPromise.then {
                self.fly(to: coord, atAltitude: altitude, atSpeed: speed)
            }
        }
        
        return flightPromise
    }
    
    func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        self.methodCall(named: "fly:on:atSpeed:")
        
        var flightPromise: Promise<Void> = firstly {
            return Promise<Void>.empty(result: ())
        }
        
        for coord in path.path {
            flightPromise = flightPromise.then {
                _ -> Promise<Void> in
                self.fly(to: coord.as2D(), atAltitude: coord.altitude, atSpeed: speed)
            }
        }
        
        return flightPromise
    }
    
    func returnHome(atAltitude altitude: DCKAltitude?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        self.methodCall(named: "returnHome:atAltitude:atSpeed:")
        
        return self.fly(to: self.homeLocation!)
    }
    
    func landingGear(down: Bool) -> Promise<Void> {
        self.methodCall(named: "landingGear:")
        
        self.isLandingGearDown = down
        
        return Promise<Void>.empty(result: ())
    }
    
    func land() -> Promise<Void> {
        self.methodCall(named: "land")
        
        let newAltitude = DCKAltitude(metersAboveSeaLevel: 0)
        self.currentAltitude = newAltitude
        
        return Promise<Void>.empty(result: ())
    }
}
