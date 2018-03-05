//
//  DCKInputTypes.swift
//  DroneCardKit
//
//  Created by Justin Manweiler on 7/27/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import CardKit

// MARK: DCKAngle

public struct DCKAngle: Codable {
    public static let zero = DCKAngle(degrees: 0)
    
    public let degrees: Double
    
    public var radians: Double {
        return degrees * .pi / 180
    }
    
    public var asNumber: NSNumber {
        return NSNumber(value: self.degrees)
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

// MARK: DCKAttitude

public struct DCKAttitude: Codable {
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

// MARK: DCKCardinalDirection

public enum DCKCardinalDirection: String {
    // https://en.wikipedia.org/wiki/Points_of_the_compass
    case north = "north"
    case northByEast = "north by east"
    case northNortheast = "north northeast"
    case northeastByNorth = "northeast by north"
    case northeast = "northeast"
    case northeastByEast = "northeast by east"
    case eastNortheast = "east northeast"
    case eastByNorth = "east by north"
    case east = "east"
    case eastBySouth = "east by south"
    case eastSoutheast = "east southeast"
    case southeastByEast = "southeast by east"
    case southeast = "southeast"
    case southeastBySouth = "southeast by south"
    case southSoutheast = "south southeast"
    case southByEast = "south by east"
    case south = "south"
    case southByWest = "south by west"
    case southSouthwest = "south southwest"
    case southwestBySouth = "southwest by south"
    case southwest = "southwest"
    case southwestByWest = "southwest by west"
    case westSouthwest = "west southwest"
    case westBySouth = "west by south"
    case west = "west"
    case westByNorth = "west by north"
    case westNorthwest = "west northwest"
    case northwestByWest = "northwest by west"
    case northwest = "northwest"
    case northwestByNorth = "northwest by north"
    case northNorthwest = "north northwest"
    case northByWest = "north by west"
    
    public var description: String {
        return self.rawValue
    }
    
    public static var values: [DCKCardinalDirection] {
        return [
            .north,
            .northByEast,
            .northNortheast,
            .northeastByNorth,
            .northeast,
            .northeastByEast,
            .eastNortheast,
            .eastByNorth,
            .east,
            .eastBySouth,
            .eastSoutheast,
            .southeastByEast,
            .southeast,
            .southeastBySouth,
            .southSoutheast,
            .southByEast,
            .south,
            .southByWest,
            .southSouthwest,
            .southwestBySouth,
            .southwest,
            .southwestByWest,
            .westSouthwest,
            .westBySouth,
            .west,
            .westByNorth,
            .westNorthwest,
            .northwestByWest,
            .northwest,
            .northwestByNorth,
            .northNorthwest,
            .northByWest
        ]
    }
    
    private var numericalValue: Int {
        if let direction = DCKCardinalDirection.values.index(of: self) {
            return direction
        } else {
            return 0
        }
    }
    
    private static let step: Double = 360 / 64.0
    
    private var base: Double {
        return DCKCardinalDirection.step * (2 * Double(self.numericalValue) - 1)
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
        return DCKCardinalDirection.values[index]
    }
}

extension DCKCardinalDirection: Codable {}

// MARK: DCKCoordinate2D

public struct DCKCoordinate2D: Codable {
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

// MARK: DCKOrientedCoordinate2D

public struct DCKOrientedCoordinate2D: Codable {
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

// MARK: DCKCoordinate3D

public struct DCKCoordinate3D: Codable {
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

// MARK: DCKOrientedCoordinate3D

public struct DCKOrientedCoordinate3D: Codable {
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

// MARK: DCKCoordinate2DPath

public struct DCKCoordinate2DPath: Codable {
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

// MARK: DCKCoordinate3DPath

public struct DCKCoordinate3DPath: Codable {
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

// MARK: DCKAbsoluteAltitude

public struct DCKAbsoluteAltitude: Codable {
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

// MARK: DCKRelativeAltitude

public struct DCKRelativeAltitude: Codable {
    public let metersAboveGroundAtTakeoff: Double
    
    public init(metersAboveGroundAtTakeoff: Double) {
        self.metersAboveGroundAtTakeoff = metersAboveGroundAtTakeoff
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

// MARK: DCKSpeed

public struct DCKSpeed: Codable {
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

// MARK: DCKDistance

public struct DCKDistance: Codable {
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

// MARK: DCKAngularVelocity

public struct DCKAngularVelocity: Codable {
    public let degreesPerSecond: Double
    
    public init(degreesPerSecond: Double) {
        self.degreesPerSecond = degreesPerSecond
    }
    
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

// MARK: DCKFrequency

public struct DCKFrequency: Codable {
    // https://en.wikipedia.org/wiki/Hertz
    public let hertz: Double

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

public struct DCKPhoto: Codable {
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

// MARK: DCKPhotoAspectRatio

public enum DCKPhotoAspectRatio: String {
    case aspect4x3 = "4x3"
    case aspect16x9 = "16x9"
    case aspect3x2 = "3x2"
}

extension DCKPhotoAspectRatio: Codable {}

extension DCKPhotoAspectRatio: Enumerable, StringEnumerable {
    public static var values: [DCKPhotoAspectRatio] {
        return [.aspect4x3, .aspect16x9, .aspect3x2]
    }
}

// MARK: DCKPhotoBurst

public struct DCKPhotoBurst: Codable {
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

// MARK: DCKPhotoBurstCount

public enum DCKPhotoBurstCount: Int {
    case burst3 = 3
    case burst5 = 5
    case burst7 = 7
    case burst10 = 10
    case burst14 = 14
}

extension DCKPhotoBurstCount: Codable {}

extension DCKPhotoBurstCount: Enumerable {
    public static var values: [DCKPhotoBurstCount] {
        return [.burst3, .burst5, .burst7, .burst10, .burst14]
    }
}

// MARK: DCKVideo

public struct DCKVideo: Codable {
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

// MARK: DCKVideoResolution

public enum DCKVideoResolution: String {
    case resolution640x480 = "640x480"
    case resolution640x512 = "640x512"
    case resolution720p = "720p"
    case resolution1080p = "1080p"
    case resolution2704x1520 = "2704x1520"
    case resolution2720x1530 = "2720x1530"
    case resolution3840x1572 = "3840x1572"
    case resolution4k = "4k"
    case resolution4096x2160 = "4096x2160"
    case resolution5280x2160 = "5280x2160"
    case max = "max"
    case noSSDVideo = "no SSD video"
    case unknown = "unknown"
}

extension DCKVideoResolution: Codable {}

extension DCKVideoResolution: Enumerable, StringEnumerable {
    public static var values: [DCKVideoResolution] {
        return [.resolution640x480, .resolution640x512, .resolution720p, .resolution1080p,
                .resolution2704x1520, .resolution2720x1530, .resolution3840x1572,
                .resolution4k, .resolution4096x2160, .resolution5280x2160,
                .max, .noSSDVideo, .unknown]
    }
}

// MARK: DCKVideoFramerate

public enum DCKVideoFramerate: String {
    case framerate23dot976fps = "23.976fps"
    case framerate24fps = "24fps"
    case framerate25fps = "25fps"
    case framerate29dot970fps = "29.970fps"
    case framerate30fps = "30fps"
    case framerate47dot950fps = "47.950fps"
    case framerate48fps = "48fps"
    case framerate50fps = "50fps"
    case framerate59dot940fps = "59.940fps"
    case framerate60fps = "60fps"
    case framerate96fps = "96fps"
    case framerate120fps = "120fps"
    case unknown = "unknown"
}

extension DCKVideoFramerate: Codable {}

extension DCKVideoFramerate: Enumerable, StringEnumerable {
    public static var values: [DCKVideoFramerate] {
        return [.framerate23dot976fps, .framerate24fps, .framerate25fps, .framerate29dot970fps,
                .framerate30fps, .framerate47dot950fps, .framerate48fps, .framerate50fps,
                .framerate59dot940fps, .framerate60fps, .framerate96fps, .framerate120fps,
                .unknown]
    }
}
