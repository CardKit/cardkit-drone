//
//  MockDroneToken.swift
//  DroneCardKit
//
//  Created by ismails on 12/9/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit
import CardKitRuntime

public class MockDroneToken: BaseMockToken, DroneToken {
    public var homeLocation: DCKCoordinate2D?
    
    public var currentLocation: DCKCoordinate2D?
    public var currentAltitude: DCKRelativeAltitude?
    public var currentAttitude: DCKAttitude?
    
    public var areMotorsOn: Bool?
    public var isLandingGearDown: Bool?
    
    override public init(with card: TokenCard) {
        self.homeLocation = DCKCoordinate2D(latitude: 0, longitude: 0)
        self.currentLocation = DCKCoordinate2D(latitude: 0, longitude: 0)
        self.currentAltitude = DCKRelativeAltitude(metersAboveGroundAtTakeoff: 0)
        self.currentAttitude = DCKAttitude(yaw: DCKAngle(degrees: 0), pitch: DCKAngle(degrees: 0), roll: DCKAngle(degrees: 0))
        self.areMotorsOn = false
        self.isLandingGearDown = true
        
        super.init(with: card)
    }
    
    // MARK: DroneToken
    
    public func spinMotors(on: Bool) throws {
        self.registerFunctionCall(named: "spinMotors")
        print("\(prefix) MockDroneToken > spinMotors(on: \(on))")
        
        Thread.sleep(forTimeInterval: delay)
        
        areMotorsOn = on
    }
    
    public func takeOff(at altitude: DCKRelativeAltitude?) throws {
        self.registerFunctionCall(named: "takeOff")
        print("\(prefix) MockDroneToken > takeOff(at: \(String(describing: altitude)))")
        
        Thread.sleep(forTimeInterval: delay)
        
        try spinMotors(on: true)
        try landingGear(down: false)
        
        var newAltitude = DCKRelativeAltitude(metersAboveGroundAtTakeoff: 1)
        
        if let specifiedAltitude = altitude {
            newAltitude = specifiedAltitude
        }
        
        self.currentAltitude = newAltitude
    }
    
    public func hover(at altitude: DCKRelativeAltitude?, withYaw yaw: DCKAngle?) throws {
        self.registerFunctionCall(named: "hover")
        print("\(prefix) MockDroneToken > hover(at: \(String(describing: altitude)), withYaw: \(String(describing: yaw)))")
        
        Thread.sleep(forTimeInterval: delay)
        
        if let specifiedAltitude = altitude {
            self.currentAltitude = specifiedAltitude
        }
    }
    
    public func fly(to coordinate: DCKCoordinate2D, atYaw yaw: DCKAngle?, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) throws {
        self.registerFunctionCall(named: "flyTo")
        print("\(prefix) MockDroneToken > fly(to: \(coordinate), atYaw: \(String(describing: yaw)), atAltitude: \(String(describing: altitude)), atSpeed: \(String(describing: speed)))")
        
        Thread.sleep(forTimeInterval: delay)
        
        guard let currentAttitude = self.currentAttitude else {
            throw DroneTokenError.failureRetrievingDroneState
        }
        
        let newYaw: DCKAngle
        
        if let yaw = yaw {
            newYaw = yaw
        } else {
            newYaw = currentAttitude.yaw
        }
        
        let newCoord = DCKCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.currentLocation = newCoord
        
        if let altitude = altitude {
            self.currentAltitude = altitude
        }
        
        let newAttitude = DCKAttitude(yaw: newYaw, pitch: currentAttitude.pitch, roll: currentAttitude.roll)
        self.currentAttitude = newAttitude
    }
    
    public func fly(on path: DCKCoordinate2DPath, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) throws {
        self.registerFunctionCall(named: "flyOn2DPath")
        print("\(prefix) MockDroneToken > fly(on: \(path), atAltitude: \(String(describing: altitude)), atSpeed: \(String(describing: speed)))")
        
        Thread.sleep(forTimeInterval: delay)
        
        for coord in path.path {
            try self.fly(to: coord, atAltitude: altitude, atSpeed: speed)
        }
    }
    
    public func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKSpeed?) throws {
        self.registerFunctionCall(named: "flyOn3DPath")
        print("\(prefix) MockDroneToken > fly(on: \(path), atSpeed: \(String(describing: speed)))")
        
        Thread.sleep(forTimeInterval: delay)
        
        for coord in path.path {
            try self.fly(to: coord.as2D(), atAltitude: coord.altitude, atSpeed: speed)
        }
    }
    
    public func circle(around center: DCKCoordinate2D, atRadius radius: DCKDistance, atAltitude altitude: DCKRelativeAltitude, atAngularVelocity angularVelocity: DCKAngularVelocity?, direction: DCKRotationDirection?, repeatedly shouldRepeat: Bool) throws {
        self.registerFunctionCall(named: "circle")
        print("\(prefix) MockDroneToken > circle(around: \(center), atRadius: \(radius), atAltitude: \(altitude), atAngularVelocity: \(String(describing: angularVelocity)), direction: \(String(describing: direction)), repeatedly: \(shouldRepeat)")
        
        Thread.sleep(forTimeInterval: delay)
    }
    
    public func returnHome(atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?, toLand land: Bool) throws {
        self.registerFunctionCall(named: "returnHome")
        print("\(prefix) MockDroneToken > returnHome(atAltitude: \(String(describing: altitude)), atSpeed: \(String(describing: speed)), toLand: \(land))")
        Thread.sleep(forTimeInterval: delay)
        
        guard let homeLocation = self.homeLocation else {
            throw DroneTokenError.failureRetrievingDroneState
        }
        
        try self.fly(to: homeLocation)
        
        if land { try self.land() }
    }
    
    public func spinAround(toYawAngle yaw: DCKAngle, atAngularVelocity angularVelocity: DCKAngularVelocity?) throws {
        self.registerFunctionCall(named: "spinAround")
        print("\(prefix) MockDroneToken > spinAround(toYawAngle: \(yaw), atAngularVelocity: \(String(describing: angularVelocity))")
        
        Thread.sleep(forTimeInterval: delay)
    }
    
    public func landingGear(down: Bool) throws {
        self.registerFunctionCall(named: "landingGear")
        print("\(prefix) MockDroneToken > landingGear(down: \(down))")
        
        Thread.sleep(forTimeInterval: delay)
        
        self.isLandingGearDown = down
    }
    
    public func land() throws {
        self.registerFunctionCall(named: "land")
        print("\(prefix) MockDroneToken > land()")
        
        Thread.sleep(forTimeInterval: delay)
        
        let newAltitude = DCKRelativeAltitude(metersAboveGroundAtTakeoff: 0)
        self.currentAltitude = newAltitude
    }
}
