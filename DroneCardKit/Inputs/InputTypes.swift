//
//  InputTypes.swift
//  DroneCardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: DCKCoordinate2D

public struct DCKCoordinate2D {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
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

public struct DCKCoordinate3D {
    public let latitude: Double
    public let longitude: Double
    public let altitudeMeters: Double
    
    public init(latitude: Double, longitude: Double, altitudeMeters: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitudeMeters = altitudeMeters
    }
}

extension DCKCoordinate3D: Equatable {
    static public func == (lhs: DCKCoordinate3D, rhs: DCKCoordinate3D) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
            && lhs.altitudeMeters == rhs.altitudeMeters
    }
}

extension DCKCoordinate3D: JSONDecodable {
    public init(json: JSON) throws {
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
        self.altitudeMeters = try json.getDouble(at: "altitudeMeters")
    }
}

extension DCKCoordinate3D: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON(),
            "altitudeMeters": self.altitudeMeters.toJSON()
            ])
    }
}

// MARK: DCKCoordinate3DPath

public struct DCKCoordinate3DPath {
    public let path: [DCKCoordinate3D]
    
    public init(path: [DCKCoordinate3D]) {
        self.path = path
    }
}

extension DCKCoordinate3DPath: Equatable {
    static public func == (lhs: DCKCoordinate3DPath, rhs: DCKCoordinate3DPath) -> Bool {
        return lhs == rhs
    }
}

extension DCKCoordinate3DPath: JSONDecodable {
    public init(json: JSON) throws {
        self.path = try json.decodedArray(type: DCKCoordinate3D.self)
    }
}

extension DCKCoordinate3DPath: JSONEncodable {
    public func toJSON() -> JSON {
        return self.path.toJSON()
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
