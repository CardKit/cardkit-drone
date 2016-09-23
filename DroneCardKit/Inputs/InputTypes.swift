//
//  InputTypes.swift
//  DroneCardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy


// MARK: Coordinate2D

public struct Coordinate2D {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Coordinate2D: Equatable {
    static public func == (lhs: Coordinate2D, rhs: Coordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
    }
}

extension Coordinate2D: JSONDecodable {
    public init(json: JSON) throws {
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
    }
}

extension Coordinate2D: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON()
            ])
    }
}

// MARK: Coordinate3D

public struct Coordinate3D {
    public let latitude: Double
    public let longitude: Double
    public let altitudeMeters: Double
    
    public init(latitude: Double, longitude: Double, altitudeMeters: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitudeMeters = altitudeMeters
    }
}

extension Coordinate3D: Equatable {
    static public func == (lhs: Coordinate3D, rhs: Coordinate3D) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
            && lhs.altitudeMeters == rhs.altitudeMeters
    }
}

extension Coordinate3D: JSONDecodable {
    public init(json: JSON) throws {
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
        self.altitudeMeters = try json.getDouble(at: "altitudeMeters")
    }
}

extension Coordinate3D: JSONEncodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON(),
            "altitudeMeters": self.altitudeMeters.toJSON()
            ])
    }
}

// MARK: CardinalDirection

public enum CardinalDirection: String {
    case north
    case south
    case east
    case west
}

extension CardinalDirection: CustomStringConvertible {
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

extension CardinalDirection: JSONDecodable {
    public init(json: JSON) throws {
        let direction = try json.getString()
        if let directionEnum = CardinalDirection(rawValue: direction) {
            self = directionEnum
        } else {
            throw JSON.Error.valueNotConvertible(value: json, to: CardinalDirection.self)
        }
    }
}

extension CardinalDirection: JSONEncodable {
    public func toJSON() -> JSON {
        return .string(self.description)
    }
}
