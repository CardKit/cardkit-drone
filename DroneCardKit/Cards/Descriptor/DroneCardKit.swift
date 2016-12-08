//
//  DroneCardKit.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 9/1/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit

/// DroneCardKit card descriptors
public struct DroneCardKit {
    fileprivate init() {}
}

// MARK: - Action Cards

extension DroneCardKit {
    /// Contains descriptors for Action cards
    public struct Action {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action {
    /// Contains descriptors for Movement cards
    public struct Movement {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Movement {
    /// Contains descriptors for Movement/Area cards
    public struct Area {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Movement.Area {
    // MARK: Movement/Area/CoverArea
    public static let CoverArea = ActionCardDescriptor(
        name: "Cover Area",
        subpath: "Movement/Area",
        inputs: [
            InputSlot(name: "Area", descriptor: DroneCardKit.Input.Location.Path, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the area has been covered.",
        assetCatalog: CardAssetCatalog(description: "Cover an area"),
        version: 0)
    
    // MARK: Movement/Area/Survey
    public static let Survey = ActionCardDescriptor(
        name: "Survey",
        subpath: "Movement/Area",
        inputs: [
            InputSlot(name: "Area", descriptor: DroneCardKit.Input.Location.BoundingBox, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the area has been surveyed.",
        assetCatalog: CardAssetCatalog(description: "Survey an area"),
        version: 0)
}

extension DroneCardKit.Action.Movement {
    /// Contains descriptors for Movement/Location cards
    public struct Location {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Movement.Location {
    // MARK: Movement/Location/Circle
    public static let Circle = ActionCardDescriptor(
        name: "Circle",
        subpath: "Movement/Location",
        inputs: [
            InputSlot(name: "Center", descriptor: DroneCardKit.Input.Location.Coordinate3D, isOptional: false),
            InputSlot(name: "Radius", descriptor: DroneCardKit.Input.Location.Distance, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the drone has made one full circle around the center coordinate",
        assetCatalog: CardAssetCatalog(description: "Circle around the target"),
        version: 0)
    
    // MARK: Movement/Location/CircleRepeatedly
    public static let CircleRepeatedly = ActionCardDescriptor(
        name: "Circle Repeatedly",
        subpath: "Movement/Location",
        inputs: [
            InputSlot(name: "Center", descriptor: DroneCardKit.Input.Location.Coordinate3D, isOptional: false),
            InputSlot(name: "Radius", descriptor: DroneCardKit.Input.Location.Distance, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
            ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Circle repeatedly around the target"),
        version: 0)
    
    // MARK: Movement/Location/FlyTo
    public static let FlyTo = ActionCardDescriptor(
        name: "Fly To",
        subpath: "Movement/Location",
        inputs: [
            InputSlot(name: "Destination", descriptor: DroneCardKit.Input.Location.Coordinate2D, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the destination is reached",
        assetCatalog: CardAssetCatalog(description: "Fly to the specified location"),
        version: 0)
    
    // MARK: Movement/Location/ReturnHome
    public static let ReturnHome = ActionCardDescriptor(
        name: "Return Home",
        subpath: "Movement/Location",
        inputs: [
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the drone has returned home",
        assetCatalog: CardAssetCatalog(description: "Return home"),
        version: 0)
}

extension DroneCardKit.Action.Movement {
    /// Contains descriptors for Movement/Orientation cards
    public struct Orientation {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Movement.Orientation {
    /// MARK: Movement/Orientation/Rotate
    public static let Rotate = ActionCardDescriptor(
        name: "Rotate",
        subpath: "Movement/Orientation",
        inputs: [
            InputSlot(name: "Angle", descriptor: DroneCardKit.Input.Location.Angle, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the drone has rotated the specified angle",
        assetCatalog: CardAssetCatalog(description: "Rotate a specified number of degrees"),
        version: 0)
    
    // MARK: Movement/Orientation/SpinAround
    public static let SpinAround = ActionCardDescriptor(
        name: "Rotate",
        subpath: "Movement/Orientation",
        inputs: [
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the drone has completely spun around",
        assetCatalog: CardAssetCatalog(description: "Spin around"),
        version: 0)
}

extension DroneCardKit.Action.Movement {
    /// Contains descriptors for Movement/Path cards
    public struct Path {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Movement.Path {
    // MARK: Movement/Path/Trace
    public static let Trace = ActionCardDescriptor(
        name: "Trace",
        subpath: "Movement/Path",
        inputs: [
            InputSlot(name: "Area", descriptor: DroneCardKit.Input.Location.Path, isOptional: false),
            InputSlot(name: "Offset", descriptor: DroneCardKit.Input.Location.Distance, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the area has been traced",
        assetCatalog: CardAssetCatalog(description: "Trace around an area"),
        version: 0)
    
    // MARK: Movement/Path/TraceRepeatedly
    public static let TraceRepeatedly = ActionCardDescriptor(
        name: "Trace",
        subpath: "Movement/Path",
        inputs: [
            InputSlot(name: "Area", descriptor: DroneCardKit.Input.Location.Path, isOptional: false),
            InputSlot(name: "Offset", descriptor: DroneCardKit.Input.Location.Distance, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Trace around an area repeatedly"),
        version: 0)
}

extension DroneCardKit.Action.Movement {
    /// Contains descriptors for Movement/Relative cards
    public struct Relative {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Movement.Relative {
    // MARK: Movement/Relative/Follow
    public static let Follow = ActionCardDescriptor(
        name: "Follow",
        subpath: "Movement/Relative",
        inputs: [
            InputSlot(name: "Object", descriptor: DroneCardKit.Input.Location.Coordinate3D, isOptional: false),
            InputSlot(name: "Distance", descriptor: DroneCardKit.Input.Location.Distance, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Follow an object"),
        version: 0)
}

extension DroneCardKit.Action.Movement {
    /// Contains descriptors for Movement/Simple cards
    public struct Simple {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Movement.Simple {
    // MARK: Movement/Simple/FlyForward
    public static let FlyForward = ActionCardDescriptor(
        name: "Fly Forward",
        subpath: "Movement/Simple",
        inputs: [
            InputSlot(name: "Distance", descriptor: DroneCardKit.Input.Location.Distance, isOptional: false),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the drone has flown the specified distance",
        assetCatalog: CardAssetCatalog(description: "Fly forward"),
        version: 0)
    
    // MARK: Movement/Simple/Hover
    public static let Hover = ActionCardDescriptor(
        name: "Hover",
        subpath: "Movement/Simple",
        inputs: [
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Hover in the air"),
        version: 0)
    
    // MARK: Movement/Simple/Land
    public static let Land = ActionCardDescriptor(
        name: "Land",
        subpath: "Movement/Simple",
        inputs: [
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the drone has landed",
        assetCatalog: CardAssetCatalog(description: "Land"),
        version: 0)
}

extension DroneCardKit.Action.Movement {
    /// Contains descriptors for Movement/Sequence cards
    public struct Sequence {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Movement.Sequence {
    // MARK: Movement/Sequence/FlyPath
    public static let FlyPath = ActionCardDescriptor(
        name: "Fly Path",
        subpath: "Movement/Sequence",
        inputs: [
            InputSlot(name: "Path", descriptor: DroneCardKit.Input.Location.Path, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the drone has flown the path",
        assetCatalog: CardAssetCatalog(description: "Fly path"),
        version: 0)
    
    // MARK: Movement/Sequence/Pace
    public static let Pace = ActionCardDescriptor(
        name: "Pace",
        subpath: "Movement/Sequence",
        inputs: [
            InputSlot(name: "Path", descriptor: DroneCardKit.Input.Location.Path, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Pace forwards and backwards along the path"),
        version: 0)
}

extension DroneCardKit.Action {
    /// Contains descriptors for Action/Tech cards
    public struct Tech {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Tech {
    /// Contains descriptors for Action/Tech/Camera cards
    public struct Camera {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Tech.Camera {
    public static let RecordVideo = ActionCardDescriptor(
        name: "Record Video",
        subpath: "Tech/Camera",
        inputs: nil,
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Record a video"),
        version: 0)
    
    public static let TakeAPhoto = ActionCardDescriptor(
        name: "Take a Photo",
        subpath: "Tech/Camera",
        inputs: nil,
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera)
        ],
        yields: [Yield(type: Data.self)],
        yieldDescription: "Yields a photo",
        ends: true,
        endsDescription: "Ends when the photo has been taken",
        assetCatalog: CardAssetCatalog(description: "Take a photo"),
        version: 0)
    
    public static let TakePhotos = ActionCardDescriptor(
        name: "Take Photos",
        subpath: "Tech/Camera",
        inputs: nil,
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera)
        ],
        yields: [Yield(type: Data.self)],
        yieldDescription: "Yields a sequence of photos",
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Take photos"),
        version: 0)
}

// TODO: Add descriptors for Claw, Gimbal, Sensor, Speaker

extension DroneCardKit.Action.Tech {
    /// Contains descriptors for Action/Tech/Claw cards
    public struct Claw {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Tech {
    /// Contains descriptors for Action/Tech/Gimbal cards
    public struct Gimbal {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Tech {
    /// Contains descriptors for Action/Tech/Sensor cards
    public struct Sensor {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Tech {
    /// Contains descriptors for Action/Tech/Speaker cards
    public struct Speaker {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action {
    /// Contains descriptors for Action/Think cards
    public struct Think {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Think {
    public static let DetectInAir = ActionCardDescriptor(
        name: "Detect In Air",
        subpath: "Think",
        inputs: [
            InputSlot(name: "Image", descriptor: CardKit.Input.Media.Image, isOptional: false)
        ],
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera),
            TokenSlot(name: "Gimbal", descriptor: DroneCardKit.Token.Gimbal)
        ],
        yields: [Yield(type: DCKCoordinate3D.self)],
        yieldDescription: "Yields the coordinate of the detected object",
        ends: true,
        endsDescription: "Ends when the object has been detected",
        assetCatalog: CardAssetCatalog(description: "Detect an object in the air"),
        version: 0)
    
    public static let DetectOnGround = ActionCardDescriptor(
        name: "Detect On Ground",
        subpath: "Think",
        inputs: [
            InputSlot(name: "Image", descriptor: CardKit.Input.Media.Image, isOptional: false)
        ],
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera),
            TokenSlot(name: "Gimbal", descriptor: DroneCardKit.Token.Gimbal)
        ],
        yields: [Yield(type: DCKCoordinate2D.self)],
        yieldDescription: "Yields the coordinate of the detected object",
        ends: true,
        endsDescription: "Ends when the object has been detected",
        assetCatalog: CardAssetCatalog(description: "Detect an object on the ground"),
        version: 0)
    
    public static let TrackInAir = ActionCardDescriptor(
        name: "Track In Air",
        subpath: "Think",
        inputs: [
            InputSlot(name: "Image", descriptor: CardKit.Input.Media.Image, isOptional: false)
        ],
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera),
            TokenSlot(name: "Gimbal", descriptor: DroneCardKit.Token.Gimbal)
        ],
        yields: [Yield(type: DCKCoordinate3D.self)],
        yieldDescription: "Yields the coordinate of the detected object",
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Track an object in the air"),
        version: 0)
    
    public static let TrackOnGround = ActionCardDescriptor(
        name: "Track On Ground",
        subpath: "Think",
        inputs: [
            InputSlot(name: "Image", descriptor: CardKit.Input.Media.Image, isOptional: false)
        ],
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera),
            TokenSlot(name: "Gimbal", descriptor: DroneCardKit.Token.Gimbal)
        ],
        yields: [Yield(type: DCKCoordinate2D.self)],
        yieldDescription: "Yields the coordinate of the detected object",
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Track an object on the ground"),
        version: 0)
}

// MARK: - Input Cards

extension DroneCardKit {
    /// Contains descriptors for Input cards
    public struct Input {
        fileprivate init() {}
    }
}

extension DroneCardKit.Input {
    /// Contains descriptors for Input/Location cards
    public struct Location {
        fileprivate init() {}
    }
}

extension DroneCardKit.Input.Location {
    // MARK: Location/Angle
    /// Descriptor for the Angle card
    public static let Angle = InputCardDescriptor(
        name: "Angle",
        subpath: "Location",
        inputType: Double.self,
        inputDescription: "Angle (in degrees)",
        assetCatalog: CardAssetCatalog(description: "Angle (in degrees)"),
        version: 0)
    
    // MARK: Location/BoundingBox
    /// Descriptor for the Bounding Box card
    public static let BoundingBox = InputCardDescriptor(
        name: "Bounding Box",
        subpath: "Location",
        inputType: DCKCoordinate2DPath.self,
        inputDescription: "Set of 2D coordinates",
        assetCatalog: CardAssetCatalog(description: "Bounding Box (2D)"),
        version: 0)
    
    // MARK: Location/BoundingBox3D
    /// Descriptor for the Bounding Box 3D card
    public static let BoundingBox3D = InputCardDescriptor(
        name: "Bounding Box 3D",
        subpath: "Location",
        inputType: DCKCoordinate3DPath.self,
        inputDescription: "Set of 3D coordinates",
        assetCatalog: CardAssetCatalog(description: "Bounding Box (3D)"),
        version: 0)
    
    // MARK: Location/CardinalDirection
    /// Descriptor for the Cardinal Direction card
    public static let CardinalDirection = InputCardDescriptor(
        name: "Cardinal Direction",
        subpath: "Location",
        inputType: DCKCardinalDirection.self,
        inputDescription: "Cardinal Direction",
        assetCatalog: CardAssetCatalog(description: "Cardinal Direction (N, S, E, W)"),
        version: 0)
    
    // MARK: Location/Distance
    /// Descriptor for the Distance card
    public static let Distance = InputCardDescriptor(
        name: "Distance",
        subpath: "Location",
        inputType: Double.self,
        inputDescription: "Distance (meters)",
        assetCatalog: CardAssetCatalog(description: "Distance (meters)"),
        version: 0)
    
    // MARK: Location/Coordinate2D
    /// Descriptor for the Coordinate2D card
    public static let Coordinate2D = InputCardDescriptor(
        name: "Coordinate 2D",
        subpath: "Location/Coordinate",
        inputType: DCKCoordinate2D.self,
        inputDescription: "Coordinate (2D)",
        assetCatalog: CardAssetCatalog(description: "2D coordinate"),
        version: 0)
    
    // MARK: Location/Coordinate3D
    /// Descriptor for the Coordinate3D card
    public static let Coordinate3D = InputCardDescriptor(
        name: "Coordinate 3D",
        subpath: "Location/Coordinate",
        inputType: DCKCoordinate3D.self,
        inputDescription: "Coordinate (3D)",
        assetCatalog: CardAssetCatalog(description: "3D coordinate"),
        version: 0)
    
    // MARK: Location/Path
    /// Descriptor for the Path card
    public static let Path = InputCardDescriptor(
        name: "Path",
        subpath: "Location",
        inputType: DCKCoordinate2DPath.self,
        inputDescription: "2D coordinate path",
        assetCatalog: CardAssetCatalog(description: "Path (2D)"),
        version: 0)
    
    // MARK: Location/Path3D
    /// Descriptor for the Path 3D card
    public static let Path3D = InputCardDescriptor(
        name: "Path 3D",
        subpath: "Location",
        inputType: DCKCoordinate3DPath.self,
        inputDescription: "3D coordinate path",
        assetCatalog: CardAssetCatalog(description: "Path (3D)"),
        version: 0)
}

extension DroneCardKit.Input {
    /// Contains descriptors for Input/Modifier cards
    public struct Modifier {
        fileprivate init() {}
    }
}

extension DroneCardKit.Input.Modifier {
    /// Contains descriptors for Input/Modifier/Movement cards
    public struct Movement {
        fileprivate init() {}
    }
}

extension DroneCardKit.Input.Modifier.Movement {
    // MARK: Modifier/Movement/Altitude
    public static let Altitude = InputCardDescriptor(
        name: "Altitude",
        subpath: "Modifier/Movement",
        inputType: DCKAltitude.self,
        inputDescription: "Altitude (in meters)",
        assetCatalog: CardAssetCatalog(description: "Altitude (in meters)"),
        version: 0)
    
    // MARK: Modifier/Movement/AngularSpeed
    public static let AngularSpeed = InputCardDescriptor(
        name: "AngularSpeed",
        subpath: "Modifier/Movement",
        inputType: DCKAngularVelocity.self,
        inputDescription: "Angular speed (in degrees/sec)",
        assetCatalog: CardAssetCatalog(description: "Angular speed (in degress/sec)"),
        version: 0)
    
    // MARK: Modifier/Movement/Speed
    public static let Speed = InputCardDescriptor(
        name: "Speed",
        subpath: "Modifier/Movement",
        inputType: DCKVelocity.self,
        inputDescription: "Speed (in meters/sec)",
        assetCatalog: CardAssetCatalog(description: "Speed (in meters/sec)"),
        version: 0)
}

extension DroneCardKit.Input {
    /// Contains descriptors for Input/Relative cards
    public struct Relative {
        fileprivate init() {}
    }
}

extension DroneCardKit.Input.Relative {
    // MARK: Relative/RelativeToLocation
    /// Descriptor for the RelativeToLocation card
    public static let RelativeToLocation = InputCardDescriptor(
        name: "Relative To Location",
        subpath: "Relative",
        inputType: DCKCoordinate2D.self,
        inputDescription: "Coordinate offset",
        assetCatalog: CardAssetCatalog(description: "A coordinate used to offset another coordinate"),
        version: 0)
    
    // MARK: Relative/RelativeToObject
    /// Descriptor for the RelativeToObject card
    public static let RelativeToObject = InputCardDescriptor(
        name: "Relative To Object",
        subpath: "Relative",
        inputType: DCKCoordinate2D.self,
        inputDescription: "Coordinate offset",
        assetCatalog: CardAssetCatalog(description: "A coordinate used to offset from an object's location"),
        version: 0)
}

// MARK: - Token Cards

extension DroneCardKit {
    /// Contains descriptors for Token cards
    public struct Token {
        fileprivate init() {}
    }
}

extension DroneCardKit.Token {
    public static let Drone = TokenCardDescriptor(
        name: "Drone",
        subpath: nil,
        isConsumed: true,
        assetCatalog: CardAssetCatalog(description: "Drone token"),
        version: 0)
 
    public static let Camera = TokenCardDescriptor(
        name: "Camera",
        subpath: nil,
        isConsumed: false,
        assetCatalog: CardAssetCatalog(description: "Camera token"),
        version: 0)
    
    public static let Gimbal = TokenCardDescriptor(
        name: "Gimbal",
        subpath: nil,
        isConsumed: false,
        assetCatalog: CardAssetCatalog(description: "Gimbal token"),
        version: 0)
}

/*
        public struct Claw {
            fileprivate init() {}
            fileprivate static let _subclass = CardPath(parent: _class, label : "Claw")
            
            public static let OpenClaw : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Open Claw",
                ends: true,
                tokens: ["claw" : Token.Claw])
            public static let CloseClaw : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Close Claw",
                ends: true,
                tokens: ["claw" : Token.Claw])
        }
        
        public struct Gimbal {
            fileprivate init() {}
            fileprivate static let _subclass = CardPath(parent: _class, label : "Gimbal")
            
            public static let PanBetween : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Pan Between",
                ends: false,
                tokens: ["gimbal" : Token.Gimbal])
            public static let PointAtFront : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Point at Front",
                ends: false,
                tokens: ["gimbal" : Token.Gimbal])
            public static let PointAtGround : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Point at Ground",
                ends: false,
                tokens: ["gimbal" : Token.Gimbal])
            public static let PointAtLocation : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Point at Location",
                ends: false,
                mandatoryInputs: ["location" : BaseCardDescs.Input.Location.Location],
                tokens: ["gimbal" : Token.Gimbal])
            public static let PointInDirectionOfMovement : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Point in Direction of Movement",
                ends: false,
                tokens: ["gimbal" : Token.Gimbal])
            public static let PointInCardinalDirection : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Point in Cardinal Direction",
                ends: false,
                mandatoryInputs: ["direction" : BaseCardDescs.Input.Location.CardinalDirection],
                tokens: ["gimbal" : Token.Gimbal])
        }
        
        public struct Sensor {
            fileprivate init() {}
            fileprivate static let _subclass = CardPath(parent: _class, label : "Sensor")
            
            public static let LogGas : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Log Gas",
                ends: false,
                mandatoryInputs: ["period" : BaseCardDescs.Input.Time.Periodicity],
                tokens: ["sensor" : Token.Humidity])
            public static let LogHumidity : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Log Humidity",
                ends: false,
                mandatoryInputs: ["period" : BaseCardDescs.Input.Time.Periodicity],
                tokens: ["sensor" : Token.Humidity])
        }
        
        public struct Speaker {
            fileprivate init() {}
            fileprivate static let _subclass = CardPath(parent: _class, label : "Speaker")
            
            public static let PlayAudio : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Play Audio",
                ends: true,
                mandatoryInputs: ["audio" : BaseCardDescs.Input.Media.Audio],
                tokens: ["speaker" : Token.Speaker])
            public static let PlayAudioLoop : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Play Audio Loop",
                ends: false,
                mandatoryInputs: ["audio" : BaseCardDescs.Input.Media.Audio],
                tokens: ["speaker" : Token.Speaker])
        }
    }
 
    public struct Think {
        fileprivate init() {}
        fileprivate static let _class = CardPath(parent: _root, label : "Think")
        
        public struct Find {
            fileprivate init() {}
            fileprivate static let _subclass = CardPath(parent: _class, label : "Find")
            
            public static let DetectInAir : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Detect in Air",
                ends: true,
                mandatoryInputs: ["image" : BaseCardDescs.Input.Media.Image],
                tokens: ["gimbal" : Token.Gimbal, "camera" : Token.Camera])
            public static let DetectOnGround : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Detect on Ground",
                ends: true,
                mandatoryInputs: ["image" : BaseCardDescs.Input.Media.Image],
                tokens: ["gimbal" : Token.Gimbal, "camera" : Token.Camera])
            public static let TrackInAir : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Track in Air",
                ends: false,
                mandatoryInputs: ["image" : BaseCardDescs.Input.Media.Image],
                tokens: ["gimbal" : Token.Gimbal, "camera" : Token.Camera])
            public static let TrackOnGround : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Track on Ground",
                ends: false,
                mandatoryInputs: ["image" : BaseCardDescs.Input.Media.Image],
                tokens: ["gimbal" : Token.Gimbal, "camera" : Token.Camera])
        }
    }
    
    public struct Trigger {
        fileprivate init() {}
        fileprivate static let _class = CardPath(parent: _root, label : "Trigger")
        
        public struct Movement {
            fileprivate init() {}
            fileprivate static let _subclass = CardPath(parent: _class, label : "Movement")
            
            public static let WaitUntilLocation : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Wait until Location",
                ends: true,
                mandatoryInputs: ["location" : BaseCardDescs.Input.Location.Location])
            
        }
        
        public struct Tech {
            fileprivate init() {}
            fileprivate static let _subclass = CardPath(parent: _class, label : "Tech")
            
            public static let WaitForButtonPush : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Wait for Button Push",
                ends: true,
                tokens: ["button" : Token.Button])
            public static let WaitForGas : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Wait for Gas",
                ends: true,
                mandatoryInputs: ["threshold" : BaseCardDescs.Input.Numeric.Real],
                tokens: ["sensor" : Token.Gas])
            public static let WaitForHumidity : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Wait for Humidity",
                ends: true,
                mandatoryInputs: ["threshold" : BaseCardDescs.Input.Numeric.Real],
                tokens: ["sensor" : Token.Humidity])
        }
    }
    
    public struct Token {
        fileprivate init() {}
        fileprivate static let _class = CardPath(parent: _root, label : "Token")
        
        public static let Gas = TokenCardDesc(
            path: _class,
            name: "Gas",
            consumed: false)
        public static let Humidity = TokenCardDesc(
            path: _class,
            name: "Humidity",
            consumed: false)
        public static let Button = TokenCardDesc(
            path: _class,
            name: "Button",
            consumed: true)
        public static let Claw = TokenCardDesc(
            path: _class,
            name: "Claw",
            consumed: true)
        public static let Speaker = TokenCardDesc(
            path: _class,
            name: "Speaker",
            consumed: true)
    }
}
*/
