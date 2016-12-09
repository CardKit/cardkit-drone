//
//  TestDroneToken.swift
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

// swiftlint:disable variable_name

public class TestDroneToken: ExecutableTokenCard, DroneToken {
    //MARK: - Properties for Unit Testing
    var val_homeLocation: DCKCoordinate2D
    var val_currentLocation: DCKCoordinate3D
    var val_currentOrientation: DCKOrientation
    var val_motorOn: Bool
    
    var funcCalled_areMotorsOn: Bool
    var funcCalled_hover: Bool
    var funcCalled_flyToAltitudeWithYawAtSpeed: Bool
    var funcCalled_flyToCoordinateAtAltitudeWithYawAtSpeed: Bool
    var funcCalled_flyOn2DPathAtSpeed: Bool
    var funcCalled_flyOn3DPathAtSpeed: Bool
    var funcCalled_returnHome: Bool
    var funcCalled_landingGear: Bool
    var funcCalled_land: Bool
    
    
    //MARK: - Functions for Unit Testing
    
    //MARK: - Initializers
    override init(with card: TokenCard) {
        self.val_homeLocation = DCKCoordinate2D(latitude: 0, longitude: 0)
        self.val_currentLocation = DCKCoordinate3D(latitude: 0, longitude: 0, altitude: DCKAltitude(metersAboveSeaLevel: 0))
        self.val_currentOrientation = DCKOrientation(yaw: DCKAngle(degrees: 10), pitch: DCKAngle(degrees: 10), roll: DCKAngle(degrees: 10))
        self.val_motorOn = false
        
        self.funcCalled_areMotorsOn = false
        self.funcCalled_areMotorsOn = false
        self.funcCalled_hover = false
        self.funcCalled_flyToAltitudeWithYawAtSpeed = false
        self.funcCalled_flyToCoordinateAtAltitudeWithYawAtSpeed = false
        self.funcCalled_flyOn2DPathAtSpeed = false
        self.funcCalled_flyOn3DPathAtSpeed = false
        self.funcCalled_returnHome = false
        self.funcCalled_landingGear = false
        self.funcCalled_land = false
        
        super.init(with: card)
    }
    
    //MARK: - Protocol Methods
    public func areMotorsOn() -> Promise<Bool> {
        self.funcCalled_areMotorsOn = true
        return Promise<Bool>.empty(result: true)
    }
    
    public func motors(spinning: Bool) -> Promise<Void> {
        self.val_motorOn = spinning
        return Promise<Void>.empty(result: ())
    }
    
    public func currentLocation() -> Promise<DCKCoordinate3D> {
        return Promise<DCKCoordinate3D>.empty(result: self.val_currentLocation)
    }
    
    public func currentOrientation() -> Promise<DCKOrientation> {
        return Promise<DCKOrientation>.empty(result: self.val_currentOrientation)
    }
    
    public func hover(withYaw yaw: DCKAngle?) -> Promise<Void> {
        self.funcCalled_hover = true
        return Promise<Void>.empty(result: ())
    }
    
    public func fly(to altitude: DCKAltitude, withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        self.funcCalled_flyToAltitudeWithYawAtSpeed = true
        return Promise<Void>.empty(result: ())
    }
    
    public func fly(to coordinate: DCKCoordinate2D, atAltitude altitude: DCKAltitude?, withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        self.funcCalled_flyToCoordinateAtAltitudeWithYawAtSpeed = true
        return Promise<Void>.empty(result: ())
    }
    
    public func fly(on path: DCKCoordinate2DPath, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        self.funcCalled_flyOn2DPathAtSpeed = true
        return Promise<Void>.empty(result: ())
    }
    
    public func fly(on path: DCKCoordinate3DPath, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        self.funcCalled_flyOn3DPathAtSpeed = true
        return Promise<Void>.empty(result: ())
        
    }
    
    public func setHome(location: DCKCoordinate2D) {
        self.val_homeLocation = location
    }
    
    public func homeLocation() -> Promise<DCKCoordinate2D> {
        return Promise<DCKCoordinate2D>.empty(result: self.val_homeLocation)
    }
    
    public func returnHome(withYaw yaw: DCKAngle?, atSpeed speed: DCKVelocity?) -> Promise<Void> {
        self.funcCalled_returnHome = true
        return Promise<Void>.empty(result: ())
    }
    
    public func landingGear(down: Bool) -> Promise<Void> {
        self.funcCalled_landingGear = true
        return Promise<Void>.empty(result: ())
    }
    
    public func land() -> Promise<Void> {
        self.funcCalled_land = true
        return Promise<Void>.empty(result: ())
    }
}
