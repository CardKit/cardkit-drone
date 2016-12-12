//
//  InputTypes.swift
//  DroneCardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

// MARK: DCKAngle

public struct DCKAngle: Equatable, Comparable {
    public static let zero = DCKAngle(degrees: 0)
    
    public let degrees: Double
    
    public var radians: Double {
        return degrees * .pi / 180
    }
    
    public init(degrees: Double) {
        self.degrees = degrees
    }
    
    public init(radians: Double) {
        self.degrees = radians * 180 / .pi
    }
    
    public func normalized() -> DCKAngle {
        let normalizedDegrees = degrees.truncatingRemainder(dividingBy: 360)
        return DCKAngle(degrees: normalizedDegrees)
    }
    
    public static func == (lhs: DCKAngle, rhs: DCKAngle) -> Bool {
        return lhs.degrees == rhs.degrees
    }
    
    public static func < (lhs: DCKAngle, rhs: DCKAngle) -> Bool {
        return lhs.degrees < rhs.degrees
    }
    
    public static func + (lhs: DCKAngle, rhs: DCKAngle) -> DCKAngle {
        return DCKAngle(degrees: lhs.degrees + rhs.degrees)
    }
    
    public static func - (lhs: DCKAngle, rhs: DCKAngle) -> DCKAngle {
        return DCKAngle(degrees: lhs.degrees - rhs.degrees)
    }
    
    public static func * (lhs: DCKAngle, rhs: DCKAngle) -> DCKAngle {
        return DCKAngle(degrees: lhs.degrees * rhs.degrees)
    }
    
    public static func * (lhs: DCKAngle, rhs: Double) -> DCKAngle {
        return DCKAngle(degrees: lhs.degrees * rhs)
    }
    
    public static func * (lhs: Double, rhs: DCKAngle) -> DCKAngle {
        return DCKAngle(degrees: lhs * rhs.degrees)
    }
    
    public static func / (lhs: DCKAngle, rhs: DCKAngle) -> DCKAngle {
        return DCKAngle(degrees: lhs.degrees / rhs.degrees)
    }
    
    public static func / (lhs: DCKAngle, rhs: Double) -> DCKAngle {
        return DCKAngle(degrees: lhs.degrees / rhs)
    }
    
    public static func / (lhs: Double, rhs: DCKAngle) -> DCKAngle {
        return DCKAngle(degrees: lhs / rhs.degrees)
    }
    
}

extension DCKAngle : JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.degrees = try json.getDouble(at: "degrees")
    }
    
    public func toJSON() -> JSON {
        return .dictionary(["degrees": degrees.toJSON()])
    }
}

// MARK: DCKAttitude

public struct DCKAttitude {
    public static let zero = DCKAttitude(yaw: DCKAngle.zero, pitch: DCKAngle.zero, roll: DCKAngle.zerio)
    
    public let yaw: DCKAngle
    public let pitch: DCKAngle
    public let roll: DCKAngle
    
    public var compassPoint: DCKCardinalDirection {
        return DCKCardinalDirection.byAngle(yaw)
    }
}

extension DCKAttitude {
    public static func + (lhs: DCKOrientation, rhs: DCKOrientation) -> DCKOrientation {
        return DCKOrientation(yaw: lhs.yaw + rhs.yaw, pitch: lhs.pitch + rhs.pitch, roll: lhs.roll + rhs.roll)
    }
    
    public static func - (lhs: DCKOrientation, rhs: DCKOrientation) -> DCKOrientation {
        return DCKOrientation(yaw: lhs.yaw - rhs.yaw, pitch: lhs.pitch - rhs.pitch, roll: lhs.roll - rhs.roll)
    }
}

extension DCKAttitude: Equatable {
    public static func == (lhs: DCKOrientation, rhs: DCKOrientation) -> Bool {
        return lhs.yaw == rhs.yaw
            && lhs.pitch == rhs.pitch
            && lhs.roll == rhs.roll
    }
}

extension DCKAttitude: JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.yaw = try json.decode(at: "yaw", type: DCKAngle.self)
        self.pitch = try json.decode(at: "pitch", type: DCKAngle.self)
        self.roll = try json.decode(at: "roll", type: DCKAngle.self)
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "yaw": self.yaw.toJSON(),
            "pitch": self.pitch.toJSON(),
            "roll": self.roll.toJSON()
            ])
    }
}

// MARK: DCKCardinalDirection

public enum DCKCardinalDirection: Int {
    // https://en.wikipedia.org/wiki/Points_of_the_compass
    case North = 0
    case NorthByEast = 1
    case NorthNortheast = 2
    case NortheastByNorth = 3
    case Northeast = 4
    case NortheastByEast = 5
    case EastNortheast = 6
    case EastByNorth = 7
    case East = 8
    case EastBySouth = 9
    case EastSoutheast = 10
    case SoutheastByEast = 11
    case Southeast = 12
    case SoutheastBySouth = 13
    case SouthSoutheast = 14
    case SouthByEast = 15
    case South = 16
    case SouthByWest = 17
    case SouthSouthwest = 18
    case SouthwestBySouth = 19
    case Southwest = 20
    case SouthwestByWest = 21
    case WestSouthwest = 22
    case WestBySouth = 23
    case West = 24
    case WestByNorth = 25
    case WestNorthwest = 26
    case NorthwestByWest = 27
    case Northwest = 28
    case NorthwestByNorth = 29
    case NorthNorthwest = 30
    case NorthByWest = 31
    
    private static let step: Double = 360 / 64.0
    
    private var base: Double {
        return DCKCardinalDirection.step * (2 * Double(self.rawValue) - 1)
    }
    
    public var min: DCKAngle {
        return DCKAngle(degrees: base).normalized()
    }
    
    public var azimuth: DCKAngle {
        return DCKAngle(degrees: base + DCKCardinalDirection.step)
    }
    
    public var max: DCKAngle {
        return DCKAngle(degrees: base + DCKCardinalDirection.step * 2)
    }
    
    public static func byAngle(_ angle: DCKAngle) -> DCKCardinalDirection {
        let index: Int = Int(((angle.degrees + DCKCardinalDirection.step) * 32) / 360) % 32
        return DCKCardinalDirection(rawValue: index)!
    }
    
}

// MARK: DCKCoordinate2D

public struct DCKCoordinate2D {
    public let latitude: Double
    public let longitude: Double
}

extension DCKCoordinate2D: Equatable {
    public static func == (lhs: DCKCoordinate2D, rhs: DCKCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
    }
}

extension DCKCoordinate2D: CustomStringConvertible {
    public var description: String {
        return "\(self.latitude), \(self.longitude)"
    }
}

extension DCKCoordinate2D: JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
    }

    public func toJSON() -> JSON {
        return .dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON()
            ])
    }
}

// MARK: DCKOrientedCoordinate2D

public struct DCKOrientedCoordinate2D: Equatable {
    public let latitude: Double
    public let longitude: Double
    public let yaw: DCKAngle
    
    public init(latitude: Double, longitude: Double, yaw: DCKAngle) {
        self.latitude = latitude
        self.longitude = longitude
        self.yaw = yaw
    }
    
    public func asNonOriented() -> DCKCoordinate2D {
        return DCKCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension DCKOrientedCoordinate2D: Equatable {
    public static func == (lhs: DCKOrientedCoordinate2D, rhs: DCKOrientedCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
            && lhs.yaw == rhs.yaw
    }
}

extension DCKOrientedCoordinate2D: CustomStringConvertible {
    public var description: String {
        return "\(self.latitude), \(self.longitude), \(self.yaw)"
    }
}

extension DCKOrientedCoordinate2D: JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
        self.yaw = try json.decode(at: "yaw", type: DCKAngle.self)
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON(),
            "yaw" : self.yaw.toJSON()
            ])
    }
}

// MARK: DCKCoordinate3D

public struct DCKCoordinate3D: Equatable {
    public let latitude: Double
    public let longitude: Double
    public let altitude: DCKAltitude
    
    public init(latitude: Double, longitude: Double, altitude: DCKAltitude) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
    
    public func as2D() -> DCKCoordinate2D {
        return DCKCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension DCKCoordinate3D: Equatable {
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
    }
    
    public init(json: JSON) throws {
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
        self.altitude = try json.decode(at: "altitude", type: DCKAltitude.self)
    }
}

// MARK: DCKOrientedCoordinate3D

public struct DCKOrientedCoordinate3D {
    public let latitude: Double
    public let longitude: Double
    public let altitude: DCKAltitude
    public let attitude: DCKAttitude
    
    public init(latitude: Double, longitude: Double, altitude: DCKAltitude, attitude: DCKAttitude) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.attitude = attitude
    }
    
    public init(latitude: Double, longitude: Double, altitude: DCKAltitude, yaw: DCKAngle = DCKAngle.zero, pitch: DCKAngle = DCKAngle.zero, roll: DCKAngle = DCKAngle.zero) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.attitude = DCKAttitude(yaw: yaw, pitch: pitch, roll: roll)
    }
    
    public func as2D() -> DCKOrientedCoordinate2D {
        return DCKOrientedCoordinate2D(latitude: latitude, longitude: longitude, yaw: orientation.yaw)
    }
    
    public func asNonOriented() -> DCKCoordinate3D {
        return DCKCoordinate3D(latitude: latitude, longitude: longitude, altitude: altitude)
    }
}

extension DCKOrientedCoordinate3D: Equatable {
    static public func == (lhs: DCKOrientedCoordinate3D, rhs: DCKOrientedCoordinate3D) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
            && lhs.altitude == rhs.altitude
            && lhs.orientation == rhs.orientation
    }
}

extension DCKOrientedCoordinate3D: CustomStringConvertible {
    public var description: String {
        return "\(self.latitude), \(self.longitude), \(self.altitude.metersAboveSeaLevel)m"
    }
}

extension DCKOrientedCoordinate3D: JSONEncodable, JSONDecodable {
    public func toJSON() -> JSON {
        return .dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON(),
            "altitude": self.altitude.toJSON(),
            "orientation": self.orientation.toJSON()
            ])
    }
    
    public init(json: JSON) throws {
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
        self.altitude = try json.decode(at: "altitude", type: DCKAltitude.self)
        self.orientation = try json.decode(at: "orientation", type: DCKOrientation.self)
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
    public static func == (lhs: DCKCoordinate2DPath, rhs: DCKCoordinate2DPath) -> Bool {
        return lhs.path == rhs.path
    }
}

extension DCKCoordinate2DPath: CustomStringConvertible {
    public var description: String {
        let strs: [String] = self.path.map { $0.description }
        return strs.joined(separator: ", ")
    }
}

extension DCKCoordinate2DPath: JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.path = try json.decodedArray(type: DCKCoordinate2D.self)
    }
    
    public func toJSON() -> JSON {
        return self.path.toJSON()
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
    public static func == (lhs: DCKCoordinate3DPath, rhs: DCKCoordinate3DPath) -> Bool {
        return lhs.path == rhs.path
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

// MARK: DCKAltitude

public struct DCKAltitude: Equatable, Comparable {
    public let metersAboveSeaLevel: Double
    
    public init (metersAboveSeaLevel: Double) {
        self.metersAboveSeaLevel = metersAboveSeaLevel
    }
}

extension DCKAltitude {
    public static func + (lhs: DCKAltitude, rhs: DCKAltitude) -> DCKAltitude {
        return DCKAltitude(metersAboveSeaLevel: lhs.metersAboveSeaLevel + rhs.metersAboveSeaLevel)
    }
    
    public static func - (lhs: DCKAltitude, rhs: DCKAltitude) -> DCKAltitude {
        return DCKAltitude(metersAboveSeaLevel: lhs.metersAboveSeaLevel - rhs.metersAboveSeaLevel)
    }
}

extension DCKAltitude: Equatable {
    public static func == (lhs: DCKAltitude, rhs: DCKAltitude) -> Bool {
        return lhs.metersAboveSeaLevel == rhs.metersAboveSeaLevel
    }
}

extension DCKAltitude: Comparable {
    public static func < (lhs: DCKAltitude, rhs: DCKAltitude) -> Bool {
        return lhs.metersAboveSeaLevel < rhs.metersAboveSeaLevel
    }
}

extension DCKAltitude : JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.metersAboveSeaLevel = try json.getDouble(at: "metersAboveSeaLevel")
    }
    
    public func toJSON() -> JSON {
        return .dictionary(["metersAboveSeaLevel": metersAboveSeaLevel.toJSON()])
    }
}

// MARK: DCKVelocity

public struct DCKVelocity {
    public let metersPerSecond: Double
    
    private static let mpsToMphConversionFactor: Double = 2.23694
    
    public var milesPerHour: Double {
        return metersPerSecond * DCKVelocity.mpsToMphConversionFactor
    }
    
    public init (metersPerSecond: Double) {
        self.metersPerSecond = metersPerSecond
    }
    
    public init (milesPerHour: Double) {
        self.metersPerSecond = milesPerHour / DCKVelocity.mpsToMphConversionFactor
    }
}

extension DCKVelocity {
    public static func + (lhs: DCKVelocity, rhs: DCKVelocity) -> DCKVelocity {
        return DCKVelocity(metersPerSecond: lhs.metersPerSecond + rhs.metersPerSecond)
    }
    
    public static func - (lhs: DCKVelocity, rhs: DCKVelocity) -> DCKVelocity {
        return DCKVelocity(metersPerSecond: lhs.metersPerSecond - rhs.metersPerSecond)
    }
}

extension DCKVelocity: Equatable {
    public static func == (lhs: DCKVelocity, rhs: DCKVelocity) -> Bool {
        return lhs.metersPerSecond == rhs.metersPerSecond
    }
}

extension DCKVelocity: Comparable {
    public static func < (lhs: DCKVelocity, rhs: DCKVelocity) -> Bool {
        return lhs.metersPerSecond < rhs.metersPerSecond
    }
}

extension DCKVelocity : JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.metersPerSecond = try json.getDouble(at: "metersPerSecond")
    }
    
    public func toJSON() -> JSON {
        return .dictionary(["metersPerSecond": metersPerSecond.toJSON()])
    }
}


// MARK: DCKAngularSpeed

public struct DCKAngularVelocity: Equatable, Comparable {
    public let degreesPerSecond: Double
    
    public var radiansPerSecond: Double {
        return degreesPerSecond * .pi / 180
    }
}

extension DCKAngularVelocity {
    public static func + (lhs: DCKAngularVelocity, rhs: DCKAngularVelocity) -> DCKAngularVelocity {
        return DCKAngularVelocity(degreesPerSecond: lhs.degreesPerSecond + rhs.degreesPerSecond)
    }
    
    public static func - (lhs: DCKAngularVelocity, rhs: DCKAngularVelocity) -> DCKAngularVelocity {
        return DCKAngularVelocity(degreesPerSecond: lhs.degreesPerSecond - rhs.degreesPerSecond)
    }
}

extension DCKAngularVelocity: Equatable {
    public static func == (lhs: DCKAngularVelocity, rhs: DCKAngularVelocity) -> Bool {
        return lhs.degreesPerSecond == rhs.degreesPerSecond
    }
}

extension DCKAngularVelocity: Comparable {
    public static func < (lhs: DCKAngularVelocity, rhs: DCKAngularVelocity) -> Bool {
        return lhs.degreesPerSecond < rhs.degreesPerSecond
    }
}

extension DCKAngularVelocity : JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.degreesPerSecond = try json.getDouble(at: "degreesPerSecond")
    }
    
    public func toJSON() -> JSON {
        return .dictionary(["degreesPerSecond": degreesPerSecond.toJSON()])
    }
}

// MARK: DCKFrequency

public struct DCKFrequency: Equatable, Comparable {
    public let hertz: Double
    
    //https://en.wikipedia.org/wiki/Hertz

    public var kilohertz: Double {
        return hertz / 1000
    }
    
    public var megahertz: Double {
        return hertz / 1000000
    }
    
    public init(hertz: Double) {
        self.hertz = hertz
    }
    
    public init(kilohertz: Double) {
        self.hertz = kilohertz * 1000
    }
    
    public init(megahertz: Double) {
        self.hertz = megahertz * 1000000
    }
}

extension DCKFrequency {
    public static func + (lhs: DCKFrequency, rhs: DCKFrequency) -> DCKFrequency {
        return DCKFrequency(hertz: lhs.hertz + rhs.hertz)
    }
    
    public static func * (lhs: DCKFrequency, rhs: Double) -> DCKFrequency {
        return DCKFrequency(hertz: lhs.hertz * rhs)
    }
    
    public static func * (lhs: Double, rhs: DCKFrequency) -> DCKFrequency {
        return DCKFrequency(hertz: lhs * rhs.hertz)
    }
    
    public static func / (lhs: DCKFrequency, rhs: Double) -> DCKFrequency {
        return DCKFrequency(hertz: lhs.hertz / rhs)
    }
    
    public static func / (lhs: Double, rhs: DCKFrequency) -> DCKFrequency {
        return DCKFrequency(hertz: lhs / rhs.hertz)
    }
}

extension DCKFrequency: Equatable {
    public static func == (lhs: DCKFrequency, rhs: DCKFrequency) -> Bool {
        return lhs.hertz == rhs.hertz
    }
}

extension DCKFrequency: Comparable {
    public static func < (lhs: DCKFrequency, rhs: DCKFrequency) -> Bool {
        return lhs.hertz < rhs.hertz
    }
}
