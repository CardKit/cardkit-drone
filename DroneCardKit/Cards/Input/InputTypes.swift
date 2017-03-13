//
//  InputTypes.swift
//  DroneCardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import Freddy

public protocol EnumerableEnum {
    static var allValues: [Self] { get }
}

extension RawRepresentable where Self: EnumerableEnum, RawValue == Int {
    public static var allValues: [Self] {
        var allValuesArr: [Self] = []
        
        var count: Int = 0
        
        var enumVal = self.init(rawValue: count)
        
        while let enumValUR = enumVal {
            allValuesArr.append(enumValUR)
            count+=1
            enumVal = self.init(rawValue: count)
        }
        
        return allValuesArr
    }
}

// MARK: DCKAngle

public struct DCKAngle {
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
        let normalizedDegrees = (degrees + 360).truncatingRemainder(dividingBy: 360)
        return DCKAngle(degrees: normalizedDegrees)
    }
}

extension DCKAngle {
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

extension DCKAngle: Equatable {
    public static func == (lhs: DCKAngle, rhs: DCKAngle) -> Bool {
        return lhs.degrees == rhs.degrees
    }
}

extension DCKAngle: Comparable {
    public static func < (lhs: DCKAngle, rhs: DCKAngle) -> Bool {
        return lhs.degrees < rhs.degrees
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
    public static let zero = DCKAttitude(yaw: DCKAngle.zero, pitch: DCKAngle.zero, roll: DCKAngle.zero)
    
    public let yaw: DCKAngle
    public let pitch: DCKAngle
    public let roll: DCKAngle
    
    public init(yaw: DCKAngle, pitch: DCKAngle, roll: DCKAngle) {
        self.yaw = yaw
        self.pitch = pitch
        self.roll = roll
    }
    
    public var compassPoint: DCKCardinalDirection {
        return DCKCardinalDirection.byAngle(yaw)
    }
}

extension DCKAttitude {
    public static func + (lhs: DCKAttitude, rhs: DCKAttitude) -> DCKAttitude {
        return DCKAttitude(yaw: lhs.yaw + rhs.yaw, pitch: lhs.pitch + rhs.pitch, roll: lhs.roll + rhs.roll)
    }
    
    public static func - (lhs: DCKAttitude, rhs: DCKAttitude) -> DCKAttitude {
        return DCKAttitude(yaw: lhs.yaw - rhs.yaw, pitch: lhs.pitch - rhs.pitch, roll: lhs.roll - rhs.roll)
    }
}

extension DCKAttitude: Equatable {
    public static func == (lhs: DCKAttitude, rhs: DCKAttitude) -> Bool {
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

public enum DCKCardinalDirection: Int, EnumerableEnum, CustomStringConvertible {

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
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public var description: String {
        switch self {
        case .North:
            return "North"
        case .NorthByEast:
            return "North by East"
        case .NorthNortheast:
            return "North Northeast"
        case .NortheastByNorth:
            return "Northeast by North"
        case .Northeast:
            return "Northeast"
        case .NortheastByEast:
            return "Northeast by East"
        case .EastNortheast:
            return "East Northeast"
        case .EastByNorth:
            return "East by North"
        case .East:
            return "East"
        case .EastBySouth:
            return "East by South"
        case .EastSoutheast:
            return "East Southeast"
        case .SoutheastByEast:
            return "Southeast by East"
        case .Southeast:
            return "Southeast"
        case .SoutheastBySouth:
            return "Southeast by South"
        case .SouthSoutheast:
            return "South Southeast"
        case .SouthByEast:
            return "South by East"
        case .South:
            return "South"
        case .SouthByWest:
            return "South by West"
        case .SouthSouthwest:
            return "South Southwest"
        case .SouthwestBySouth:
            return "Southwest by South"
        case .Southwest:
            return "Southwest"
        case .SouthwestByWest:
            return "Southwest by West"
        case .WestSouthwest:
            return "West Southwest"
        case .WestBySouth:
            return "West by South"
        case .West:
            return "West"
        case .WestByNorth:
            return "West by North"
        case .WestNorthwest:
            return "West Northwest"
        case .NorthwestByWest:
            return "Northwest by West"
        case .Northwest:
            return "Northwest"
        case .NorthwestByNorth:
            return "Northwest by North"
        case .NorthNorthwest:
            return "North Northwest"
        case .NorthByWest:
            return "North by West"
        }
    }
    
    
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

extension DCKCardinalDirection: JSONEncodable, JSONDecodable {}

// MARK: DCKCoordinate2D

public struct DCKCoordinate2D {
    static let earthsRadiusInMeters = 6371e3 //in meters
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    /// Finds the distance between two DCKCoordinate2Ds using the haversine formula.
    /// See here for more info: http://www.movable-type.co.uk/scripts/latlong.html
    ///
    /// - Parameter secondCoordinate: second coordinate used for calculating distance
    /// - Returns: returns  in meters
    public func distance(to coordinate: DCKCoordinate2D) -> Double {
        let lat1Rad = self.latitude.degreesToRadians
        let lat2Rad = coordinate.latitude.degreesToRadians
        
        let latDelta = (coordinate.latitude - self.latitude).degreesToRadians
        let lonDelta = (coordinate.longitude - self.longitude).degreesToRadians
        
        let a = sin(latDelta/2) * sin(latDelta/2) +
            cos(lat1Rad) * cos(lat2Rad) *
            sin(lonDelta/2) * sin(lonDelta/2)
        
        let angularDistanceInRadians = 2 * atan2(sqrt(a), sqrt(1-a))
        
        let distance = DCKCoordinate2D.earthsRadiusInMeters * angularDistanceInRadians
        
        return distance
    }
    
    /// Calculates the bearing (angle measureed in clockwise from North) to the second coordinate.
    /// See here for more info: http://www.movable-type.co.uk/scripts/latlong.html
    /// Also see this for more info: http://www.igismap.com/formula-to-find-bearing-or-heading-angle-between-two-points-latitude-longitude/
    ///
    /// - Parameter secondCoordinate: second coordinate used for calculating bearing
    /// - Returns: returns bearing (angle measured in clockwise from North)
    public func bearing(to coordinate: DCKCoordinate2D) -> DCKAngle {
        let lat1Rad = self.latitude.degreesToRadians
        let lat2Rad = coordinate.latitude.degreesToRadians
        
        let lon1Rad = self.longitude.degreesToRadians
        let lon2Rad = coordinate.longitude.degreesToRadians
        
        let y = sin(lon2Rad - lon1Rad) * cos(lat2Rad)
        let x = cos(lat1Rad) * sin(lat2Rad) -
            sin(lat1Rad) * cos(lat2Rad) * cos(lon2Rad - lon1Rad)
        
        let bearing = atan2(y, x).radiansToDegrees
        
        return DCKAngle(degrees: bearing)
    }
    
    
    /// Add x,y distance in meters to a lat/lon coordinate.
    /// Method: http://stackoverflow.com/questions/7477003/calculating-new-longtitude-latitude-from-old-n-meters
    /// An another approximate method: http://gis.stackexchange.com/questions/2951/algorithm-for-offsetting-a-latitude-longitude-by-some-amount-of-meters
    ///
    /// - Parameters:
    ///   - x: x distance in meters
    ///   - y: y distance in meters
    /// - Returns: a new coordinate with the added/subtracted distance in x/y
    func add(xVal: Double, yVal: Double) -> DCKCoordinate2D {
        let earthsRadiusInKM = DCKCoordinate2D.earthsRadiusInMeters/1000
        
        let newLatitude  = self.latitude  + ((yVal/1000) / earthsRadiusInKM) * (180 / .pi)
        let newLongitude = self.longitude + ((xVal/1000) / earthsRadiusInKM) * (180 / .pi) / cos(self.latitude.degreesToRadians)
        
        return DCKCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }
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

public struct DCKOrientedCoordinate2D {
    public let latitude: Double
    public let longitude: Double
    public let yaw: DCKAngle
    
    public func asNonOriented() -> DCKCoordinate2D {
        return DCKCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Compute the relative bearing angle between this coordinate (oriented toward its yaw)
    /// and the given coordinate.
    public func bearing(to coordinate: DCKCoordinate2D) -> DCKAngle {
        // calculate the absolute bearing
        let bearing = self.bearing(to: coordinate)
        
        // calculate the relative bearing
        let relativeBearing = bearing - self.yaw
        
        // return the normalized bearing (so negative angles become positive)
        return relativeBearing.normalized()
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
            "yaw": self.yaw.toJSON()
            ])
    }
}

// MARK: DCKCoordinate3D

public struct DCKCoordinate3D {
    public let latitude: Double
    public let longitude: Double
    public let altitude: DCKRelativeAltitude
    
    public init(latitude: Double, longitude: Double, altitude: DCKRelativeAltitude) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
    
    public init(coordinate: DCKCoordinate2D, altitude: DCKRelativeAltitude) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.altitude = altitude
    }
    
    public func as2D() -> DCKCoordinate2D {
        return DCKCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Compute the bearing angle between this coordinate and the given coordinate. The bearing angle
    /// is the horizontal angle between the two coordinates.  The 3D bearing is the same as the 2D bearing.
    public func bearing(to coordinate: DCKCoordinate3D) -> DCKAngle {
        // calculate 2D bearing
        return self.as2D().bearing(to: coordinate.as2D())
    }
    
    /// Compute the pitch angle between this coordinate and the given coordinate. The pitch angle is
    /// the vertical angle between the two coordinates.
    public func pitch(to coordinate: DCKCoordinate3D) -> DCKAngle {
        // we have the opposite value (change in altitude) and the hypotoneuse (distance to location)
        // sin(theta) = opposite/hypotoneuse .. which is..  sin(theta) = altitude/distance
        let altitudeDelta = coordinate.altitude.metersAboveGroundAtTakeoff - self.altitude.metersAboveGroundAtTakeoff
        let distanceToLocation = self.as2D().distance(to: coordinate.as2D())
        
        // altitudeDelta must be multiplied by -1 to map it correctly to our normalized angles
        // e.g. if altitudeDelta is -20, the end altitude is lower than the current altitude
        // since we need to to rotate downards, the angle must be positive
        let pitchAngle = asin(-1*altitudeDelta/distanceToLocation).radiansToDegrees
        let pitchAngleNormalized = DCKAngle(degrees: pitchAngle).normalized()
        
        return pitchAngleNormalized
    }
}

extension DCKCoordinate3D: Equatable {
    public static func == (lhs: DCKCoordinate3D, rhs: DCKCoordinate3D) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
            && lhs.altitude == rhs.altitude
    }
}

extension DCKCoordinate3D: CustomStringConvertible {
    public var description: String {
        return "\(self.latitude), \(self.longitude), \(self.altitude.metersAboveGroundAtTakeoff)"
    }
}

extension DCKCoordinate3D: JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
        self.altitude = try json.decode(at: "altitude", type: DCKRelativeAltitude.self)
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON(),
            "altitude": self.altitude.toJSON()
            ])
    }
}

// MARK: DCKOrientedCoordinate3D

public struct DCKOrientedCoordinate3D {
    public let latitude: Double
    public let longitude: Double
    public let altitude: DCKRelativeAltitude
    
    /// True North is 0º
    public let yaw: DCKAngle
    
    public init(latitude: Double, longitude: Double, altitude: DCKRelativeAltitude, yaw: DCKAngle) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.yaw = yaw
    }
    
    public init(coordinate2D: DCKCoordinate2D, altitude: DCKRelativeAltitude, yaw: DCKAngle) {
        self.latitude = coordinate2D.latitude
        self.longitude = coordinate2D.longitude
        self.altitude = altitude
        self.yaw = yaw
    }
    
    public func as2D() -> DCKOrientedCoordinate2D {
        return DCKOrientedCoordinate2D(latitude: latitude, longitude: longitude, yaw: yaw)
    }
    
    public func asNonOriented() -> DCKCoordinate3D {
        return DCKCoordinate3D(latitude: latitude, longitude: longitude, altitude: altitude)
    }
    
    /// Compute the relative bearing angle between this coordinate (oriented toward its yaw)
    /// and the given coordinate.
    public func bearing(to coordinate: DCKCoordinate3D) -> DCKAngle {
        // calculate the absolute bearing (true north is 0º)
        let bearing = self.asNonOriented().bearing(to: coordinate)
        
        // calculate the relative bearing
        let relativeBearing = bearing - self.yaw
        
        // return the normalized bearing (so negative angles become positive)
        return relativeBearing.normalized()
    }
    
    public func add(distance: DCKDistance) -> DCKCoordinate2D {
        let currentLocation = as2D().asNonOriented()
        
        let yawInDegrees = yaw.degrees
        let distanceInMeters = distance.meters
        
        var xOffset: Double = 0
        var yOffset: Double = 0
        
        // handle 0, 90, 180, 270
        if yawInDegrees == 0 || yawInDegrees == 360 {
            yOffset = distanceInMeters
        } else if yawInDegrees == 90 {
            xOffset = distanceInMeters
        } else if yawInDegrees == 180 {
            yOffset = -1*distanceInMeters
        } else if yawInDegrees == 270 {
            xOffset = -1*distanceInMeters
        } else {
            // we would like to get the yaw relative to (0, 90, 180, 270) angles in a quadrant (in a unit circle)
            // for example, quadrant 3 (180 to 270) starts at 180, if yawInDegrees is 190, the relative angle is 10
            var relativeYaw = yawInDegrees.truncatingRemainder(dividingBy: 90)
            
            // now we are make sure the angle is with respect to the x axis of the unit circle (so.. 90 and 270 degrees)
            // using the example above, if we are in quadrant 3, and yawInDegrees is 190, the relative angle should now be 80 (270-190 = 80)
            if (yawInDegrees > 0 && yawInDegrees < 90) || (yawInDegrees > 180 && yawInDegrees < 270) {
                relativeYaw = 90 - relativeYaw
            }
            
            // with the new relative angles, we can safely say that the opposite side of the triangle is y,
            // the adjacent is x, and the hypotenuse is distanceInMeters
            
            // calculate opposite
            yOffset = sin(relativeYaw.degreesToRadians) * distanceInMeters
            
            // calculate adjacent
            xOffset = cos(relativeYaw.degreesToRadians) * distanceInMeters
            
            // set signs
            if yawInDegrees > 0 && yawInDegrees < 90 {
                xOffset = abs(xOffset)
                yOffset = abs(yOffset)
            } else if yawInDegrees > 90 && yawInDegrees < 180 {
                xOffset = abs(xOffset)
                yOffset = -1*yOffset
            } else if yawInDegrees > 180 && yawInDegrees < 270 {
                xOffset = -1*xOffset
                yOffset = -1*yOffset
            } else if yawInDegrees > 270 && yawInDegrees < 360 {
                xOffset = -1*xOffset
                yOffset = abs(yOffset)
            }
        }
        
        return currentLocation.add(xVal: xOffset, yVal: yOffset)
    }
}

extension DCKOrientedCoordinate3D: Equatable {
    public static func == (lhs: DCKOrientedCoordinate3D, rhs: DCKOrientedCoordinate3D) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
            && lhs.yaw == rhs.yaw
    }
}

extension DCKOrientedCoordinate3D: CustomStringConvertible {
    public var description: String {
        return "\(self.latitude), \(self.longitude), \(self.altitude.metersAboveGroundAtTakeoff)m"
    }
}

extension DCKOrientedCoordinate3D: JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.latitude = try json.getDouble(at: "latitude")
        self.longitude = try json.getDouble(at: "longitude")
        self.altitude = try json.decode(at: "altitude", type: DCKRelativeAltitude.self)
        self.yaw = try json.decode(at: "yaw", type: DCKAngle.self)
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "latitude": self.latitude.toJSON(),
            "longitude": self.longitude.toJSON(),
            "altitude": self.altitude.toJSON(),
            "yaw": self.yaw.toJSON()
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

// MARK: DCKAbsoluteAltitude

public struct DCKAbsoluteAltitude {
    public let metersAboveSeaLevel: Double
}

extension DCKAbsoluteAltitude {
    public static func + (lhs: DCKAbsoluteAltitude, rhs: DCKAbsoluteAltitude) -> DCKAbsoluteAltitude {
        return DCKAbsoluteAltitude(metersAboveSeaLevel: lhs.metersAboveSeaLevel + rhs.metersAboveSeaLevel)
    }
    
    public static func - (lhs: DCKAbsoluteAltitude, rhs: DCKAbsoluteAltitude) -> DCKAbsoluteAltitude {
        return DCKAbsoluteAltitude(metersAboveSeaLevel: lhs.metersAboveSeaLevel - rhs.metersAboveSeaLevel)
    }
}

extension DCKAbsoluteAltitude: Equatable {
    public static func == (lhs: DCKAbsoluteAltitude, rhs: DCKAbsoluteAltitude) -> Bool {
        return lhs.metersAboveSeaLevel == rhs.metersAboveSeaLevel
    }
}

extension DCKAbsoluteAltitude: Comparable {
    public static func < (lhs: DCKAbsoluteAltitude, rhs: DCKAbsoluteAltitude) -> Bool {
        return lhs.metersAboveSeaLevel < rhs.metersAboveSeaLevel
    }
}

extension DCKAbsoluteAltitude : JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.metersAboveSeaLevel = try json.getDouble(at: "metersAboveSeaLevel")
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "metersAboveSeaLevel": metersAboveSeaLevel.toJSON()
            ])
    }
}

// MARK: DCKRelativeAltitude

public struct DCKRelativeAltitude {
    public let metersAboveGroundAtTakeoff: Double
    
    public init(metersAboveGroundAtTakeoff: Double) {
        self.metersAboveGroundAtTakeoff = metersAboveGroundAtTakeoff
    }
}

extension DCKRelativeAltitude: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.metersAboveGroundAtTakeoff = value
    }
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.metersAboveGroundAtTakeoff = Double(value)
    }
}

extension DCKRelativeAltitude {
    public static func + (lhs: DCKRelativeAltitude, rhs: DCKRelativeAltitude) -> DCKRelativeAltitude {
        return DCKRelativeAltitude(metersAboveGroundAtTakeoff: lhs.metersAboveGroundAtTakeoff + rhs.metersAboveGroundAtTakeoff)
    }
    
    public static func - (lhs: DCKRelativeAltitude, rhs: DCKRelativeAltitude) -> DCKRelativeAltitude {
        return DCKRelativeAltitude(metersAboveGroundAtTakeoff: lhs.metersAboveGroundAtTakeoff - rhs.metersAboveGroundAtTakeoff)
    }
}

extension DCKRelativeAltitude: Equatable {
    public static func == (lhs: DCKRelativeAltitude, rhs: DCKRelativeAltitude) -> Bool {
        return lhs.metersAboveGroundAtTakeoff == rhs.metersAboveGroundAtTakeoff
    }
}

extension DCKRelativeAltitude: Comparable {
    public static func < (lhs: DCKRelativeAltitude, rhs: DCKRelativeAltitude) -> Bool {
        return lhs.metersAboveGroundAtTakeoff < rhs.metersAboveGroundAtTakeoff
    }
}

extension DCKRelativeAltitude : JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.metersAboveGroundAtTakeoff = try json.getDouble(at: "metersAboveGroundAtTakeoff")
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "metersAboveGroundAtTakeoff": metersAboveGroundAtTakeoff.toJSON()
            ])
    }
}

// MARK: DCKSpeed

public struct DCKSpeed {
    public let metersPerSecond: Double
    
    private static let mpsToMphConversionFactor: Double = 2.23694
    
    public var milesPerHour: Double {
        return metersPerSecond * DCKSpeed.mpsToMphConversionFactor
    }
    
    public init(metersPerSecond: Double) {
        self.metersPerSecond = metersPerSecond
    }
    
    public init(milesPerHour: Double) {
        self.metersPerSecond = milesPerHour / DCKSpeed.mpsToMphConversionFactor
    }
}

extension DCKSpeed {
    public static func + (lhs: DCKSpeed, rhs: DCKSpeed) -> DCKSpeed {
        return DCKSpeed(metersPerSecond: lhs.metersPerSecond + rhs.metersPerSecond)
    }
    
    public static func - (lhs: DCKSpeed, rhs: DCKSpeed) -> DCKSpeed {
        return DCKSpeed(metersPerSecond: lhs.metersPerSecond - rhs.metersPerSecond)
    }
}

extension DCKSpeed: Equatable {
    public static func == (lhs: DCKSpeed, rhs: DCKSpeed) -> Bool {
        return lhs.metersPerSecond == rhs.metersPerSecond
    }
}

extension DCKSpeed: Comparable {
    public static func < (lhs: DCKSpeed, rhs: DCKSpeed) -> Bool {
        return lhs.metersPerSecond < rhs.metersPerSecond
    }
}

extension DCKSpeed : JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.metersPerSecond = try json.getDouble(at: "metersPerSecond")
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "metersPerSecond": metersPerSecond.toJSON()
            ])
    }
}

// MARK: DCKDistance

public struct DCKDistance {
    public let meters: Double
    
    private static let footToMeterConversionFactor: Double = 0.3048
    
    public init(meters: Double) {
        self.meters = meters
    }
    
    public init(feet: Double) {
        self.meters = feet * DCKDistance.footToMeterConversionFactor
    }
}

extension DCKDistance {
    public static func + (lhs: DCKDistance, rhs: DCKDistance) -> DCKDistance {
        return DCKDistance(meters: lhs.meters + rhs.meters)
    }
    
    public static func - (lhs: DCKDistance, rhs: DCKDistance) -> DCKDistance {
        return DCKDistance(meters: lhs.meters - rhs.meters)
    }
}

extension DCKDistance: Equatable {
    public static func == (lhs: DCKDistance, rhs: DCKDistance) -> Bool {
        return lhs.meters == rhs.meters
    }
}

extension DCKDistance: Comparable {
    public static func < (lhs: DCKDistance, rhs: DCKDistance) -> Bool {
        return lhs.meters < rhs.meters
    }
}

extension DCKDistance : JSONDecodable, JSONEncodable {
    public init(json: JSON) throws {
        self.meters = try json.getDouble(at: "meters")
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "meters": meters.toJSON()
            ])
    }
}

// MARK: DCKRotationDirection

public enum DCKRotationDirection: String, EnumerableEnum, CustomStringConvertible {
    case clockwise
    case counterClockwise
    
    public static var allValues: [DCKRotationDirection] {
        return [.clockwise, .counterClockwise]
    }
    
    public var description: String {
        switch self {
        case .clockwise:
            return "Clockwise"
        case .counterClockwise:
            return "Counterclockwise"
        }
    }
}

extension DCKRotationDirection: JSONEncodable, JSONDecodable {}

// MARK: DCKAngularVelocity

public struct DCKAngularVelocity {
    public let degreesPerSecond: Double
    
    public init(degreesPerSecond: Double) {
        self.degreesPerSecond = degreesPerSecond
    }
    
    public var radiansPerSecond: Double {
        return degreesPerSecond * .pi / 180
    }
    
    public var rotationDirection: DCKRotationDirection {
        return degreesPerSecond < 0 ? .counterClockwise : .clockwise
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

public struct DCKFrequency {
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

// MARK: DCKPhoto

public struct DCKPhoto {
    public let fileName: String
    public internal (set) var pathInLocalFileSystem: URL?
    public let sizeInBytes: UInt
    public let timeCreated: Date
    public lazy var photoData: Data? = {
        // read from pathInLocalFileSystem
        guard let path = self.pathInLocalFileSystem else { return nil }
        do {
            return try Data(contentsOf: path)
        } catch {
            return nil
        }
    }()
    public var location: DCKCoordinate3D?
    
    public init(fileName: String, sizeInBytes: UInt, timeCreated: Date, data: Data, location: DCKCoordinate3D?) {
        self.fileName = fileName
        self.sizeInBytes = sizeInBytes
        self.timeCreated = timeCreated
        self.location = location
        
        // save to Cache directory
        self.saveToCacheDirectory(data: data)
    }
}

extension DCKPhoto {
    mutating func saveToLocalFileSystem(at path: URL, data: Data) {
        let lfsPath = path.appendingPathComponent(fileName)
        do {
            try data.write(to: lfsPath)
            self.pathInLocalFileSystem = lfsPath
        } catch let error {
            print("error writing DCKPhoto to local file system: \(error)")
        }
    }
    
    mutating func saveToCacheDirectory(data: Data) {
        do {
            let cacheDir = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            self.saveToLocalFileSystem(at: cacheDir, data: data)
        } catch let error {
            print("error obtaining Caches directory: \(error)")
        }
    }
}

extension DCKPhoto: JSONEncodable, JSONDecodable {
    public init(json: JSON) throws {
        self.fileName = try json.getString(at: "fileName")
        
        let lfsPath = try json.getString(at: "pathInLocalFileSystem")
        if lfsPath == "nil" {
            self.pathInLocalFileSystem = nil
        } else {
            self.pathInLocalFileSystem = URL(fileURLWithPath: lfsPath)
        }
        
        let size = try json.getInt(at: "sizeInBytes")
        self.sizeInBytes = UInt(size)
        
        self.timeCreated = try json.decode(at: "timeCreated", type: Date.self)
        
        let locationStr = try json.getString(at: "location")
        if locationStr == "nil" {
            self.location = nil
        } else {
            self.location = try json.decode(at: "location", type: DCKCoordinate3D.self)
        }
    }
    
    public func toJSON() -> JSON {
        // NOTE: we do not serialize photoData since it would already be in
        // the local file system (assuming pathInLocalFileSystem is not nil)
        return .dictionary([
            "fileName": self.fileName.toJSON(),
            "pathInLocalFileSystem": self.pathInLocalFileSystem?.absoluteString.toJSON() ?? .string("nil"),
            "sizeInBytes": Int(self.sizeInBytes).toJSON(),
            "timeCreated": self.timeCreated.toJSON(),
            "location": self.location?.toJSON() ?? .string("nil")
            ])
    }
}

// MARK: DCKPhotoAspectRatio

public enum DCKPhotoAspectRatio: String, EnumerableEnum, CustomStringConvertible {
    case aspect_4x3
    case aspect_16x9
    case aspect_3x2
    
    public static var allValues: [DCKPhotoAspectRatio] {
        return [.aspect_4x3, .aspect_16x9, .aspect_3x2]
    }
    
    public var description: String {
        switch self {
        case .aspect_4x3:
            return "4x3"
        case .aspect_16x9:
            return "16x9"
        case .aspect_3x2:
            return "3x2"
        }
    }
}

extension DCKPhotoAspectRatio: JSONEncodable, JSONDecodable {}

// MARK: DCKPhotoQuality

public enum DCKPhotoQuality: String, EnumerableEnum, CustomStringConvertible {
    case normal
    case fine
    case excellent
    
    public static var allValues: [DCKPhotoQuality] {
        return [.normal, .fine, .excellent]
    }
    
    public var description: String {
        switch self {
        case .normal:
            return "Normal"
        case .fine:
            return "Fine"
        case .excellent:
            return "Excellent"
        }
    }
}

extension DCKPhotoQuality: JSONEncodable, JSONDecodable {}

// MARK: DCKPhotoBurst

public struct DCKPhotoBurst {
    public internal (set) var photos: [DCKPhoto] = []
    
    public init(photos: [DCKPhoto]) {
        self.photos = photos
    }
    
    mutating func add(photo: DCKPhoto) {
        self.photos.append(photo)
    }
    
    mutating func add(photos: [DCKPhoto]) {
        self.photos.append(contentsOf: photos)
    }
}

extension DCKPhotoBurst: JSONEncodable, JSONDecodable {
    public init(json: JSON) throws {
        self.photos = try json.decodedArray(at: "photos", type: DCKPhoto.self)
    }
    
    public func toJSON() -> JSON {
        return .dictionary([
            "photos": self.photos.toJSON()
            ])
    }
}

// MARK: DCKPhotoBurstCount

public enum DCKPhotoBurstCount: Int, EnumerableEnum, CustomStringConvertible {
    case burst_3 = 3
    case burst_5 = 5
    case burst_7 = 7
    case burst_10 = 10
    case burst_14 = 14
    
    public static var allValues: [DCKPhotoBurstCount] {
        return [.burst_3, .burst_5, .burst_7, .burst_10, .burst_14]
    }
    
    public var description: String {
        switch self {
        case .burst_3:
            return "3 Photos"
        case .burst_5:
            return "5 Photos"
        case .burst_7:
            return "7 Photos"
        case .burst_10:
            return "10 Photos"
        case .burst_14:
            return "14 Photos"
        }
    }
}

extension DCKPhotoBurstCount: JSONEncodable, JSONDecodable {}

// MARK: DCKVideo

public struct DCKVideo {
    public let fileName: String
    public internal (set) var pathInLocalFileSystem: URL?
    public let sizeInBytes: UInt
    public let timeCreated: Date
    public let durationInSeconds: Double
    public lazy var videoData: Data? = {
        // read from pathInLocalFileSystem
        guard let path = self.pathInLocalFileSystem else { return nil }
        do {
            return try Data(contentsOf: path)
        } catch {
            return nil
        }
    }()
    
    public init(fileName: String, sizeInBytes: UInt, timeCreated: Date, durationInSeconds: Double, data: Data) {
        self.fileName = fileName
        self.pathInLocalFileSystem = nil
        self.sizeInBytes = sizeInBytes
        self.timeCreated = timeCreated
        self.durationInSeconds = durationInSeconds
        
        // save to Cache directory
        self.saveToCacheDirectory(data: data)
    }
}

extension DCKVideo {
    mutating func saveToLocalFileSystem(at path: URL, data: Data) {
        let lfsPath = path.appendingPathComponent(fileName)
        do {
            try data.write(to: lfsPath)
            self.pathInLocalFileSystem = lfsPath
        } catch let error {
            print("error writing DCKVideo to local file system: \(error)")
        }
    }
    
    mutating func saveToCacheDirectory(data: Data) {
        do {
            let cacheDir = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            self.saveToLocalFileSystem(at: cacheDir, data: data)
        } catch let error {
            print("error obtaining Caches directory: \(error)")
        }
    }
}

extension DCKVideo: JSONEncodable, JSONDecodable {
    public init(json: JSON) throws {
        self.fileName = try json.getString(at: "fileName")
        
        let lfsPath = try json.getString(at: "pathInLocalFileSystem")
        if lfsPath == "nil" {
            self.pathInLocalFileSystem = nil
        } else {
            self.pathInLocalFileSystem = URL(fileURLWithPath: lfsPath)
        }
        
        let size = try json.getInt(at: "sizeInBytes")
        self.sizeInBytes = UInt(size)
        
        self.timeCreated = try json.decode(at: "timeCreated", type: Date.self)
        self.durationInSeconds = try json.getDouble(at: "durationInSeconds")
    }
    
    public func toJSON() -> JSON {
        // NOTE: we do not serialize videoData since it would already be in
        // the local file system (assuming pathInLocalFileSystem is not nil)
        return .dictionary([
            "fileName": self.fileName.toJSON(),
            "pathInLocalFileSystem": self.pathInLocalFileSystem?.absoluteString.toJSON() ?? .string("nil"),
            "sizeInBytes": Int(self.sizeInBytes).toJSON(),
            "timeCreated": self.timeCreated.toJSON(),
            "durationInSeconds": self.durationInSeconds.toJSON()
            ])
    }
}

// MARK: DCKVideoResolution

public enum DCKVideoResolution: String, EnumerableEnum, CustomStringConvertible {
    case resolution_640x480
    case resolution_640x512
    case resolution_720p
    case resolution_1080p
    case resolution_2704x1520
    case resolution_2720x1530
    case resolution_3840x1572
    case resolution_4k
    case resolution_4096x2160
    case resolution_5280x2160
    case max
    case noSSDVideo
    case unknown
    
    public static var allValues: [DCKVideoResolution] {
        return [.resolution_640x480, .resolution_640x512, .resolution_720p, .resolution_1080p, .resolution_2704x1520, .resolution_2720x1530, .resolution_3840x1572, .resolution_4k, .resolution_4096x2160, .resolution_5280x2160, .max, .noSSDVideo, .unknown]
    }
    
    public var description: String {
        switch self {
        case .resolution_640x480:
            return "640 x 480"
        case .resolution_640x512:
            return "640 x 512"
        case .resolution_720p:
            return "720p"
        case .resolution_1080p:
            return "1080p"
        case .resolution_2704x1520:
            return "2704 x 1520"
        case .resolution_2720x1530:
            return "2720 x 1530"
        case .resolution_3840x1572:
            return "3840 x 1572"
        case .resolution_4k:
            return "4k"
        case .resolution_4096x2160:
            return "4096 x 2160"
        case .resolution_5280x2160:
            return "5280 x 2160"
        case .max:
            return "Max"
        case .noSSDVideo:
            return "No SSD Video"
        case .unknown:
            return "Unknown"
        }
    }
}

extension DCKVideoResolution: JSONEncodable, JSONDecodable {}

// MARK: DCKVideoFramerate

public enum DCKVideoFramerate: String, EnumerableEnum, CustomStringConvertible {
    case framerate_23dot976fps
    case framerate_24fps
    case framerate_25fps
    case framerate_29dot970fps
    case framerate_30fps
    case framerate_47dot950fps
    case framerate_48fps
    case framerate_50fps
    case framerate_59dot940fps
    case framerate_60fps
    case framerate_96fps
    case framerate_120fps
    case unknown
    
    public static var allValues: [DCKVideoFramerate] {
        return [.framerate_23dot976fps, .framerate_24fps, .framerate_25fps, .framerate_29dot970fps, .framerate_30fps, .framerate_47dot950fps, .framerate_48fps, .framerate_50fps, .framerate_59dot940fps, .framerate_60fps, .framerate_96fps, .framerate_120fps, .unknown]
    }
    
    public var description: String {
        switch self {
        case .framerate_23dot976fps:
            return "23.976 fps"
        case .framerate_24fps:
            return "24 fps"
        case .framerate_25fps:
            return "25 fps"
        case .framerate_29dot970fps:
            return "29.970 fps"
        case .framerate_30fps:
            return "30 fps"
        case .framerate_47dot950fps:
            return "47.950 fps"
        case .framerate_48fps:
            return "48 fps"
        case .framerate_50fps:
            return "50 fps"
        case .framerate_59dot940fps:
            return "59.940 fps"
        case .framerate_60fps:
            return "60 fps"
        case .framerate_96fps:
            return "96 fps"
        case .framerate_120fps:
            return "120 fps"
        case .unknown:
            return "Unknown"
        }
    }
}

extension DCKVideoFramerate: JSONEncodable, JSONDecodable {}
