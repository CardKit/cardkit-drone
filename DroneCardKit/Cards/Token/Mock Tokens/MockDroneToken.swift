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

public class MockDroneToken: BaseMockToken {
    public var homeLocation: DCKCoordinate2D?
    public var currentLocation: DCKCoordinate2D?
    public var currentAltitude: DCKRelativeAltitude?
    public var currentAttitude: DCKAttitude?
    
    public var isFlying: Bool
    public var areMotorsOn: Bool
    public var isLandingGearDown: Bool
    
    override public init(with card: TokenCard) {
        self.homeLocation = DCKCoordinate2D(latitude: 0, longitude: 0)
        self.currentLocation = DCKCoordinate2D(latitude: 0, longitude: 0)
        self.currentAltitude = DCKRelativeAltitude(metersAboveGroundAtTakeoff: 0)
        self.currentAttitude = DCKAttitude(yaw: DCKAngle(degrees: 0), pitch: DCKAngle(degrees: 0), roll: DCKAngle(degrees: 0))
        self.isFlying = false
        self.areMotorsOn = false
        self.isLandingGearDown = true
        
        super.init(with: card)
    }
}

extension MockDroneToken: DroneToken {
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
    
    public func hover(at altitude: DCKRelativeAltitude?) throws {
        self.registerFunctionCall(named: "hover")
        print("\(prefix) MockDroneToken > hover(at: \(String(describing: altitude))")
        
        Thread.sleep(forTimeInterval: delay)
        
        if let specifiedAltitude = altitude {
            self.currentAltitude = specifiedAltitude
        }
    }
    
    public func orient(to yaw: DCKAngle) throws {
        self.registerFunctionCall(named: "orient")
        print("\(prefix) MockDroneToken > orient(to: \(yaw))")
        
        Thread.sleep(forTimeInterval: delay)
        
        if let currentAttitude = self.currentAttitude {
            self.currentAttitude = DCKAttitude(yaw: yaw, pitch: currentAttitude.pitch, roll: currentAttitude.roll)
        } else {
            self.currentAttitude = DCKAttitude(yaw: yaw, pitch: DCKAngle(degrees: 0), roll: DCKAngle(degrees: 0))
        }
    }
    
    public func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKRelativeAltitude?, atSpeed speed: DCKSpeed?) throws {
        self.registerFunctionCall(named: "flyTo")
        print("\(prefix) MockDroneToken > fly(to: \(coordinate), atAltitude: \(String(describing: altitude)), atSpeed: \(String(describing: speed)))")
        
        Thread.sleep(forTimeInterval: delay)
        
        let newCoord = DCKCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.currentLocation = newCoord
        
        if let altitude = altitude {
            self.currentAltitude = altitude
        }
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
    
    public func circle(around center: DCKCoordinate2D, atRadius radius: DCKDistance, atAltitude altitude: DCKRelativeAltitude?, atAngularVelocity angularVelocity: DCKAngularVelocity?) throws {
        self.registerFunctionCall(named: "circle")
        print("\(prefix) MockDroneToken > circle(around: \(center), atRadius: \(radius), atAltitude: \(String(describing: altitude)), atAngularVelocity: \(String(describing: angularVelocity))")
        
        Thread.sleep(forTimeInterval: delay)
    }
    
    public func returnHome() throws {
        self.registerFunctionCall(named: "returnHome")
        print("\(prefix) MockDroneToken > returnHome()")
        Thread.sleep(forTimeInterval: delay)
        
        guard let homeLocation = self.homeLocation else {
            throw DroneTokenError.failureRetrievingDroneState
        }
        
        try self.fly(to: homeLocation)
        try self.land()
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
