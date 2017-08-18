//
//  DroneCardKit.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 9/1/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit
import CardKitRuntime

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
        assetCatalog: CardAssetCatalog(description: "Cover an area"))
    
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
        assetCatalog: CardAssetCatalog(description: "Survey an area"))
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
            InputSlot(name: "Center", descriptor: DroneCardKit.Input.Location.Coordinate2D, isOptional: false),
            InputSlot(name: "Radius", descriptor: DroneCardKit.Input.Location.Distance, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: false),
            InputSlot(name: "AngularVelocity", descriptor: DroneCardKit.Input.Modifier.Movement.AngularVelocity, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the drone has made one full circle around the center coordinate",
        assetCatalog: CardAssetCatalog(description: "Circle around the target"))
    
    // MARK: Movement/Location/CircleRepeatedly
    public static let CircleRepeatedly = ActionCardDescriptor(
        name: "Circle Repeatedly",
        subpath: "Movement/Location",
        inputs: [
            InputSlot(name: "Center", descriptor: DroneCardKit.Input.Location.Coordinate2D, isOptional: false),
            InputSlot(name: "Radius", descriptor: DroneCardKit.Input.Location.Distance, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: false),
            InputSlot(name: "AngularVelocity", descriptor: DroneCardKit.Input.Modifier.Movement.AngularVelocity, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Circle repeatedly around the target"))
    
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
        assetCatalog: CardAssetCatalog(description: "Fly to the specified location"))
    
    // MARK: Movement/Location/ReturnHome
    public static let ReturnHome = ActionCardDescriptor(
        name: "Return Home",
        subpath: "Movement/Location",
        inputs: nil,
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the drone has returned home",
        assetCatalog: CardAssetCatalog(description: "Return home"))
}

extension DroneCardKit.Action.Movement {
    /// Contains descriptors for Movement/Orientation cards
    public struct Orientation {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Movement.Orientation {
    /// MARK: Movement/Orientation/Rotate
    public static let SpinAround = ActionCardDescriptor(
        name: "Sping Around",
        subpath: "Movement/Orientation",
        inputs: [
            InputSlot(name: "Angle", descriptor: DroneCardKit.Input.Location.Angle, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "AngularVelocity", descriptor: DroneCardKit.Input.Modifier.Movement.AngularVelocity, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the drone has spinned around the specified angle",
        assetCatalog: CardAssetCatalog(description: "Spin around a specified number of degrees"))
    
    // MARK: Movement/Orientation/SpinAround
    public static let SpinAroundRepeatedly = ActionCardDescriptor(
        name: "Sping Around Repeatedly",
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
        assetCatalog: CardAssetCatalog(description: "Spin around"))
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
        assetCatalog: CardAssetCatalog(description: "Trace around an area"))
    
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
        assetCatalog: CardAssetCatalog(description: "Trace around an area repeatedly"))
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
        assetCatalog: CardAssetCatalog(description: "Follow an object"))
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
        assetCatalog: CardAssetCatalog(description: "Fly forward"))
    
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
        assetCatalog: CardAssetCatalog(description: "Hover in the air"))
    
    // MARK: Movement/Simple/Land
    public static let Land = ActionCardDescriptor(
        name: "Land",
        subpath: "Movement/Simple",
        inputs: nil,
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the drone has landed",
        assetCatalog: CardAssetCatalog(description: "Land"))
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
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true),
            InputSlot(name: "PauseDuration", descriptor: CardKit.Input.Time.Duration, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the drone has flown the path",
        assetCatalog: CardAssetCatalog(description: "Fly path"))
    
    // MARK: Movement/Sequence/Pace
    public static let Pace = ActionCardDescriptor(
        name: "Pace",
        subpath: "Movement/Sequence",
        inputs: [
            InputSlot(name: "Path", descriptor: DroneCardKit.Input.Location.Path, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true),
            InputSlot(name: "Speed", descriptor: DroneCardKit.Input.Modifier.Movement.Speed, isOptional: true),
            InputSlot(name: "PauseDuration", descriptor: CardKit.Input.Time.Duration, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Drone", descriptor: DroneCardKit.Token.Drone)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Pace forwards and backwards along the path"))
}

extension DroneCardKit.Action.Movement {
    /// Contains descriptors for Movement/Trigger cards
    public struct Trigger {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Movement.Trigger {
    // MARK: Movement/Trigger/WaitUntilLocation
    public static let WaitUntilLocation = ActionCardDescriptor(
        name: "Wait Until Location",
        subpath: "Movement/Trigger",
        inputs: [
            InputSlot(name: "Location", descriptor: DroneCardKit.Input.Location.Coordinate2D, isOptional: false),
            InputSlot(name: "Altitude", descriptor: DroneCardKit.Input.Modifier.Movement.Altitude, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Telemetry", descriptor: DroneCardKit.Token.Telemetry)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: true,
        endsDescription: "Ends when the specified location is reached",
        assetCatalog: CardAssetCatalog(description: "Waits until the specified location is reached"))
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
        inputs: [
            InputSlot(name: "Framerate", descriptor: DroneCardKit.Input.Camera.Framerate, isOptional: true),
            InputSlot(name: "Resolution", descriptor: DroneCardKit.Input.Camera.Resolution, isOptional: true),
            InputSlot(name: "SlowMotionEnabled", descriptor: CardKit.Input.Logical.Boolean, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera)
        ],
        yields: [Yield(type: DCKVideo.self)],
        yieldDescription: "Yields a video",
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Record a video"))
    
    public static let TakePhoto = ActionCardDescriptor(
        name: "Take a Photo",
        subpath: "Tech/Camera",
        inputs: [
            InputSlot(name: "HDR", descriptor: CardKit.Input.Logical.Boolean, isOptional: true),
            InputSlot(name: "AspectRatio", descriptor: DroneCardKit.Input.Camera.AspectRatio, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera)
        ],
        yields: [Yield(type: DCKPhoto.self)],
        yieldDescription: "Yields a photo",
        ends: true,
        endsDescription: "Ends when the photo has been taken",
        assetCatalog: CardAssetCatalog(description: "Take a photo"))
    
    public static let TakePhotoBurst = ActionCardDescriptor(
        name: "Take a Photo Burst",
        subpath: "Tech/Camera",
        inputs: [
            InputSlot(name: "BurstCount", descriptor: DroneCardKit.Input.Camera.BurstCount, isOptional: false),
            InputSlot(name: "AspectRatio", descriptor: DroneCardKit.Input.Camera.AspectRatio, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera)
        ],
        yields: [Yield(type: DCKPhotoBurst.self)],
        yieldDescription: "Yields a photo burst",
        ends: true,
        endsDescription: "Ends when the photo burst has been taken",
        assetCatalog: CardAssetCatalog(description: "Take a photo burst"))
    
    public static let TakePhotos = ActionCardDescriptor(
        name: "Take Photos",
        subpath: "Tech/Camera",
        inputs: [
            InputSlot(name: "Frequency", descriptor: CardKit.Input.Time.Periodicity, isOptional: false),
            InputSlot(name: "AspectRatio", descriptor: DroneCardKit.Input.Camera.AspectRatio, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera)
        ],
        yields: [Yield(type: DCKPhotoBurst.self)],
        yieldDescription: "Yields a sequence of photos",
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Take photos"))
    
    public static let TakeTimelapse = ActionCardDescriptor(
        name: "Take a Timelapse",
        subpath: "Tech/Camera",
        inputs: [
            InputSlot(name: "AspectRatio", descriptor: DroneCardKit.Input.Camera.AspectRatio, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Camera", descriptor: DroneCardKit.Token.Camera)
        ],
        yields: [Yield(type: DCKVideo.self)],
        yieldDescription: "Yields a timelapse video",
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Take a timelapse"))
}

extension DroneCardKit.Action.Tech {
    /// Contains descriptors for Action/Tech/Gimbal cards
    public struct Gimbal {
        fileprivate init() {}
    }
}

extension DroneCardKit.Action.Tech.Gimbal {
    public static let PanBetweenLocations = ActionCardDescriptor(
        name: "Pan Between Locations",
        subpath: "Tech/Gimbal",
        inputs: [
            InputSlot(name: "StartLocation", descriptor: DroneCardKit.Input.Location.Coordinate3D, isOptional: false),
            InputSlot(name: "EndLocation", descriptor: DroneCardKit.Input.Location.Coordinate3D, isOptional: false),
            InputSlot(name: "Duration", descriptor: CardKit.Input.Time.Duration, isOptional: true)
        ],
        tokens: [
            TokenSlot(name: "Gimbal", descriptor: DroneCardKit.Token.Gimbal),
            TokenSlot(name: "Telemetry", descriptor: DroneCardKit.Token.Telemetry)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Pan Between Locations"))
    
    public static let PointAtFront = ActionCardDescriptor(
        name: "Point at Front",
        subpath: "Tech/Gimbal",
        inputs: nil,
        tokens: [
            TokenSlot(name: "Gimbal", descriptor: DroneCardKit.Token.Gimbal)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Point at Front"))
    
    public static let PointAtGround = ActionCardDescriptor(
        name: "Point at Ground",
        subpath: "Tech/Gimbal",
        inputs: nil,
        tokens: [
            TokenSlot(name: "Gimbal", descriptor: DroneCardKit.Token.Gimbal)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Point at Ground"))
    
    public static let PointAtLocation = ActionCardDescriptor(
        name: "Point at Location",
        subpath: "Tech/Gimbal",
        inputs: [
            InputSlot(name: "Location", descriptor: DroneCardKit.Input.Location.Coordinate3D, isOptional: false)
        ],
        tokens: [
            TokenSlot(name: "Gimbal", descriptor: DroneCardKit.Token.Gimbal),
            TokenSlot(name: "Telemetry", descriptor: DroneCardKit.Token.Telemetry)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Point at Location"))
    
    public static let PointInDirection = ActionCardDescriptor(
        name: "Point in Direction",
        subpath: "Tech/Gimbal",
        inputs: [
            InputSlot(name: "CardinalDirection", descriptor: DroneCardKit.Input.Location.CardinalDirection, isOptional: false)
        ],
        tokens: [
            TokenSlot(name: "Gimbal", descriptor: DroneCardKit.Token.Gimbal),
            TokenSlot(name: "Telemetry", descriptor: DroneCardKit.Token.Telemetry)
        ],
        yields: nil,
        yieldDescription: nil,
        ends: false,
        endsDescription: nil,
        assetCatalog: CardAssetCatalog(description: "Point in Direction"))
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

// MARK: - Input Cards

extension DroneCardKit {
    /// Contains descriptors for Input cards
    public struct Input {
        fileprivate init() {}
    }
}

extension DroneCardKit.Input {
    /// Contains descriptors for Input/Camera cards
    public struct Camera {
        fileprivate init() {}
    }
}

extension DroneCardKit.Input.Camera {
    // MARK: Camera/AspectRatio
    /// Descriptor for the AspectRatio card
    public static let AspectRatio = InputCardDescriptor(
        name: "Aspect Ratio",
        subpath: "Camera",
        inputType: DCKPhotoAspectRatio.self,
        inputDescription: "Photo aspect ratio (16x9 or 4x3)",
        assetCatalog: CardAssetCatalog(description: "Aspect ratio"))
    
    // MARK: Camera/BurstCount
    /// Descriptor for the BurstCount card
    public static let BurstCount = InputCardDescriptor(
        name: "Burst Count",
        subpath: "Camera",
        inputType: DCKPhotoBurstCount.self,
        inputDescription: "Photo burst count",
        assetCatalog: CardAssetCatalog(description: "Burst count"))
    
    // MARK: Camera/Framerate
    /// Descriptor for the Framerate card
    public static let Framerate = InputCardDescriptor(
        name: "Framerate",
        subpath: "Camera",
        inputType: DCKVideoFramerate.self,
        inputDescription: "Video framerate",
        assetCatalog: CardAssetCatalog(description: "Framerate"))
    
    // MARK: Camera/Resolution
    /// Descriptor for the Resolution card
    public static let Resolution = InputCardDescriptor(
        name: "Resolution",
        subpath: "Camera",
        inputType: DCKVideoResolution.self,
        inputDescription: "Video resolution",
        assetCatalog: CardAssetCatalog(description: "Resolution"))
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
        inputType: DCKAngle.self,
        inputDescription: "Angle (in degrees)",
        assetCatalog: CardAssetCatalog(description: "Angle (in degrees)"))
    
    // MARK: Location/BoundingBox
    /// Descriptor for the Bounding Box card
    public static let BoundingBox = InputCardDescriptor(
        name: "Bounding Box",
        subpath: "Location",
        inputType: DCKCoordinate2DPath.self,
        inputDescription: "Set of 2D coordinates",
        assetCatalog: CardAssetCatalog(description: "Bounding Box (2D)"))
    
    // MARK: Location/BoundingBox3D
    /// Descriptor for the Bounding Box 3D card
    public static let BoundingBox3D = InputCardDescriptor(
        name: "Bounding Box 3D",
        subpath: "Location",
        inputType: DCKCoordinate3DPath.self,
        inputDescription: "Set of 3D coordinates",
        assetCatalog: CardAssetCatalog(description: "Bounding Box (3D)"))
    
    // MARK: Location/CardinalDirection
    /// Descriptor for the Cardinal Direction card
    public static let CardinalDirection = InputCardDescriptor(
        name: "Cardinal Direction",
        subpath: "Location",
        inputType: DCKCardinalDirection.self,
        inputDescription: "Cardinal Direction",
        assetCatalog: CardAssetCatalog(description: "Cardinal Direction (N, S, E, W)"))
    
    // MARK: Location/Distance
    /// Descriptor for the Distance card
    public static let Distance = InputCardDescriptor(
        name: "Distance",
        subpath: "Location",
        inputType: DCKDistance.self,
        inputDescription: "Distance (meters)",
        assetCatalog: CardAssetCatalog(description: "Distance (meters)"))
    
    // MARK: Location/Coordinate2D
    /// Descriptor for the Coordinate2D card
    public static let Coordinate2D = InputCardDescriptor(
        name: "Coordinate 2D",
        subpath: "Location/Coordinate",
        inputType: DCKCoordinate2D.self,
        inputDescription: "Coordinate (2D)",
        assetCatalog: CardAssetCatalog(description: "2D coordinate"))
    
    // MARK: Location/Coordinate3D
    /// Descriptor for the Coordinate3D card
    public static let Coordinate3D = InputCardDescriptor(
        name: "Coordinate 3D",
        subpath: "Location/Coordinate",
        inputType: DCKCoordinate3D.self,
        inputDescription: "Coordinate (3D)",
        assetCatalog: CardAssetCatalog(description: "3D coordinate"))
    
    // MARK: Location/Path
    /// Descriptor for the Path card
    public static let Path = InputCardDescriptor(
        name: "Path",
        subpath: "Location",
        inputType: DCKCoordinate2DPath.self,
        inputDescription: "2D coordinate path",
        assetCatalog: CardAssetCatalog(description: "Path (2D)"))
    
    // MARK: Location/Path3D
    /// Descriptor for the Path 3D card
    public static let Path3D = InputCardDescriptor(
        name: "Path 3D",
        subpath: "Location",
        inputType: DCKCoordinate3DPath.self,
        inputDescription: "3D coordinate path",
        assetCatalog: CardAssetCatalog(description: "Path (3D)"))
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
        inputType: DCKRelativeAltitude.self,
        inputDescription: "Altitude (in meters)",
        assetCatalog: CardAssetCatalog(description: "Altitude (in meters)"))
    
    // MARK: Modifier/Movement/AngularVelocity
    public static let AngularVelocity = InputCardDescriptor(
        name: "AngularVelocity",
        subpath: "Modifier/Movement",
        inputType: DCKAngularVelocity.self,
        inputDescription: "Angular velocity (in degrees/sec). Positive values indicate clockwise direction, negative values indicate counterclockwise direction.",
        assetCatalog: CardAssetCatalog(description: "Angular velocity (in degress/sec)"))
    
    // MARK: Modifier/Movement/Speed
    public static let Speed = InputCardDescriptor(
        name: "Speed",
        subpath: "Modifier/Movement",
        inputType: DCKSpeed.self,
        inputDescription: "Speed (in meters/sec)",
        assetCatalog: CardAssetCatalog(description: "Speed (in meters/sec)"))
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
        assetCatalog: CardAssetCatalog(description: "A coordinate used to offset another coordinate"))
    
    // MARK: Relative/RelativeToObject
    /// Descriptor for the RelativeToObject card
    public static let RelativeToObject = InputCardDescriptor(
        name: "Relative To Object",
        subpath: "Relative",
        inputType: DCKCoordinate2D.self,
        inputDescription: "Coordinate offset",
        assetCatalog: CardAssetCatalog(description: "A coordinate used to offset from an object's location"))
}

// MARK: - Token Cards

extension DroneCardKit {
    /// Contains descriptors for Token cards
    public struct Token {
        fileprivate init() {}
    }
}

extension DroneCardKit.Token {
    public static let Camera = TokenCardDescriptor(
        name: "Camera",
        subpath: nil,
        isConsumed: false,
        assetCatalog: CardAssetCatalog(description: "Camera token"))
    
    public static let Drone = TokenCardDescriptor(
        name: "Drone",
        subpath: nil,
        isConsumed: true,
        assetCatalog: CardAssetCatalog(description: "Drone token"))
    
    public static let Gimbal = TokenCardDescriptor(
        name: "Gimbal",
        subpath: nil,
        isConsumed: false,
        assetCatalog: CardAssetCatalog(description: "Gimbal token"))
    
    public static let Telemetry = TokenCardDescriptor(
        name: "Telemetry",
        subpath: nil,
        isConsumed: false,
        assetCatalog: CardAssetCatalog(description: "Drone telemetry token"))
}
