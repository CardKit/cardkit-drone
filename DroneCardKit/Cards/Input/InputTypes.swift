//
//  InputTypes.swift
//  DroneCardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public struct DCKAltitude: Equatable  {
    public let metersAboveSeaLevel: Double
    
    public init (metersAboveSeaLevel: Double) {
        self.metersAboveSeaLevel = metersAboveSeaLevel
    }
    
    static public func == (lhs: DCKAltitude, rhs: DCKAltitude) -> Bool {
        return lhs.metersAboveSeaLevel == rhs.metersAboveSeaLevel
    }
}

extension DCKAltitude : JSONEncodable, JSONDecodable {
    public init(json: JSON) throws {
        self.metersAboveSeaLevel = try json.getDouble(at: "metersAboveSeaLevel")
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "metersAboveSeaLevel": metersAboveSeaLevel.toJSON(),
            ])
    }
}

public struct DCKVelocity {
    public let metersPerSec: Double
    
    public var milesPerHour : Double {
        get {
            // TODO: compute
            return 0
        }
    }
    
    public init (metersPerSec: Double) {
        self.metersPerSec = metersPerSec
    }
}

public struct DCKAngle {
    public let degrees: Double
    
    public var radians : Double {
        get {
            // TODO:
            return 0
        }
    }
    
}

public struct DCKOrientation {
    public let yaw: DCKAngle
    public let pitch: DCKAngle
    public let roll: DCKAngle
    
}



// MARK: DCKCoordinate2D

public struct DCKCoordinate2D {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension DCKCoordinate2D: CustomStringConvertible {
    public var description: String {
        return "\(self.latitude), \(self.longitude)"
    }
}

extension DCKCoordinate2D: Equatable {
    static public func == (lhs: DCKCoordinate2D, rhs: DCKCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
    }
}

extension DCKCoordinate2D: JSONDecodable {
    public init(json: JSON) throws {
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
    }
}

extension DCKCoordinate2D: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON()
            ])
    }
}

// MARK: DCKCoordinate2DPath

public struct DCKCoordinate2DPath {
    public let path: [DCKCoordinate2D]
    
    public init(path: [DCKCoordinate2D]) {
        self.path = path
    }
}

extension DCKCoordinate2DPath: CustomStringConvertible {
    public var description: String {
        let strs: [String] = self.path.map { $0.description }
        return strs.joined(separator: ", ")
    }
}

extension DCKCoordinate2DPath: Equatable {
    static public func == (lhs: DCKCoordinate2DPath, rhs: DCKCoordinate2DPath) -> Bool {
        return lhs == rhs
    }
}

extension DCKCoordinate2DPath: JSONDecodable {
    public init(json: JSON) throws {
        self.path = try json.decodedArray(type: DCKCoordinate2D.self)
    }
}

extension DCKCoordinate2DPath: JSONEncodable {
    public func toJSON() -> JSON {
        return self.path.toJSON()
    }
}

// MARK: DCKCoordinate3D

public struct DCKCoordinate3D: Equatable {
    public let latitude: Double
    public let longitude: Double
    public let altitude: DCKAltitude
    
    public var as2D : DCKCoordinate2D {
        get {
            return DCKCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    public init(latitude: Double, longitude: Double, altitude: DCKAltitude) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
    
    static public func == (lhs: DCKCoordinate3D, rhs: DCKCoordinate3D) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
            && lhs.altitude == rhs.altitude
    }
}

extension DCKCoordinate3D: CustomStringConvertible {
    public var description: String {
        return "\(self.latitude), \(self.longitude), \(self.altitude.metersAboveSeaLevel)m"
    }
}

extension DCKCoordinate3D: JSONEncodable, JSONDecodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON(),
            "altitude": self.altitude.toJSON()
            ])
    
    public init(json: JSON) throws {
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
        self.altitude = nil;try DCKAltitude(json: json.(at: "altitude"))
    }
}

// MARK: DCKCoordinate3DPath

    public struct DCKCoordinate3DPath : Equatable {
    public let path: [DCKCoordinate3D]
    
    public init(path: [DCKCoordinate3D]) {
        self.path = path
    }
    
    static public func == (lhs: DCKCoordinate3DPath, rhs: DCKCoordinate3DPath) -> Bool {
        return lhs == rhs
    }
}

extension DCKCoordinate3DPath: CustomStringConvertible {
    public var description: String {
        let strs: [String] = self.path.map { $0.description }
        return strs.joined(separator: ", ")
    }
}
    
extension DCKCoordinate3DPath: JSONEncodable, JSONDecodable {
    public func toJSON() -> JSON {
        return self.path.toJSON()
    }
    
    public init(json: JSON) throws {
        self.path = try json.decodedArray(type: DCKCoordinate3D.self)
    }
}

// MARK: DCKCardinalDirection

public enum DCKCardinalDirection: String {
    case north
    case south
    case east
    case west
}

extension DCKCardinalDirection: CustomStringConvertible {
    public var description: String {
        switch self {
        case .north:
            return "north"
        case .south:
            return "south"
        case .east:
            return "east"
        case .west:
            return "west"
        }
    }
}

extension DCKCardinalDirection: JSONDecodable {
    public init(json: JSON) throws {
        let direction = try json.getString()
        if let directionEnum = DCKCardinalDirection(rawValue: direction) {
            self = directionEnum
        } else {
            throw JSON.Error.valueNotConvertible(value: json, to: DCKCardinalDirection.self)
        }
    }
}

extension DCKCardinalDirection: JSONEncodable {
    public func toJSON() -> JSON {
        return .string(self.description)
    }
}
