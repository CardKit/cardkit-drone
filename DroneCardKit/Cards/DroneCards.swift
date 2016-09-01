//
//  DroneCards.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 9/1/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit

public struct DroneCards {
    private init() {}
    
    //MARK:- Movement Cards
    
    /// Contains descriptors for Movement cards
    public struct Movement {
        private init() {}
        
        /// Contains descriptors for Movement/Area cards
        public struct Area {
            private init() {}
            
            //MARK: Movement/Area/CoverArea
            public static let CoverArea = ActionCardDescriptor(
                name: "Cover Area",
                subpath: "Movement/Area",
                inputs: [
                    InputSlot(name: "Area", type: .Coordinate2DPath, isOptional: false),
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: true,
                endsDescription: "Ends when the area has been covered.",
                assetCatalog: CardAssetCatalog(description: "Cover an area"),
                version: 0)
            
            //MARK: Movement/Area/Survey
            public static let Survey = ActionCardDescriptor(
                name: "Survey",
                subpath: "Movement/Area",
                inputs: [
                    InputSlot(name: "Area", type: .Coordinate2DPath, isOptional: false),
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: true,
                endsDescription: "Ends when the area has been surveyed.",
                assetCatalog: CardAssetCatalog(description: "Survey an area"),
                version: 0)
        }
        
        /// Contains descriptors for Movement/Location cards
        public struct Location {
            private init() {}
            
            //MARK: Movement/Location/Circle
            public static let Circle = ActionCardDescriptor(
                name: "Circle",
                subpath: "Movement/Location",
                inputs: [
                    InputSlot(name: "Center", type: .Coordinate2D, isOptional: false),
                    InputSlot(name: "Radius", type: .SwiftDouble, isOptional: false),
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: true,
                endsDescription: "Ends when the drone has made one full circle around the center coordinate",
                assetCatalog: CardAssetCatalog(description: "Circle around the target"),
                version: 0)
            
            //MARK: Movement/Location/CircleRepeatedly
            public static let CircleRepeatedly = ActionCardDescriptor(
                name: "Circle Repeatedly",
                subpath: "Movement/Location",
                inputs: [
                    InputSlot(name: "Center", type: .Coordinate2D, isOptional: false),
                    InputSlot(name: "Radius", type: .SwiftDouble, isOptional: false),
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true),
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: false,
                endsDescription: nil,
                assetCatalog: CardAssetCatalog(description: "Circle repeatedly around the target"),
                version: 0)
            
            //MARK: Movement/Location/FlyTo
            public static let FlyTo = ActionCardDescriptor(
                name: "Fly To",
                subpath: "Movement/Location",
                inputs: [
                    InputSlot(name: "Destination", type: .Coordinate2D, isOptional: false),
                    InputSlot(name: "Radius", type: .SwiftDouble, isOptional: false),
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: true,
                endsDescription: "Ends when the destination is reached",
                assetCatalog: CardAssetCatalog(description: "Fly to the specified location"),
                version: 0)
            
            //MARK: Movement/Location/ReturnHome
            public static let ReturnHome = ActionCardDescriptor(
                name: "Return Home",
                subpath: "Movement/Location",
                inputs: [
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: true,
                endsDescription: "Ends when the drone has returned home",
                assetCatalog: CardAssetCatalog(description: "Return home"),
                version: 0)
        }
        
        /// Contains descriptors for Movement/Orientation cards
        public struct Orientation {
            private init() {}
            
            ///MARK: Movement/Orientation/Rotate
            public static let Rotate = ActionCardDescriptor(
                name: "Rotate",
                subpath: "Movement/Orientation",
                inputs: [
                    InputSlot(name: "Angle", type: .SwiftDouble, isOptional: false),
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: true,
                endsDescription: "Ends when the drone has rotated the specified angle",
                assetCatalog: CardAssetCatalog(description: "Rotate a specified number of degrees"),
                version: 0)
            
            //MARK: Movement/Orientation/SpinAround
            public static let SpinAround = ActionCardDescriptor(
                name: "Rotate",
                subpath: "Movement/Orientation",
                inputs: [
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: true,
                endsDescription: "Ends when the drone has completely spun around",
                assetCatalog: CardAssetCatalog(description: "Spin around"),
                version: 0)
        }
        
        /// Contains descriptors for Movement/Path cards
        public struct Path {
            private init() {}
            
            //MARK: Movement/Path/Trace
            public static let Trace = ActionCardDescriptor(
                name: "Trace",
                subpath: "Movement/Path",
                inputs: [
                    InputSlot(name: "Area", type: .Coordinate2DPath, isOptional: false),
                    InputSlot(name: "Offset", type: .SwiftDouble, isOptional: false),
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: true,
                endsDescription: "Ends when the area has been traced",
                assetCatalog: CardAssetCatalog(description: "Trace around an area"),
                version: 0)
            
            //MARK: Movement/Path/TraceRepeatedly
            public static let TraceRepeatedly = ActionCardDescriptor(
                name: "Trace",
                subpath: "Movement/Path",
                inputs: [
                    InputSlot(name: "Area", type: .Coordinate2DPath, isOptional: false),
                    InputSlot(name: "Offset", type: .SwiftDouble, isOptional: false),
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: false,
                endsDescription: nil,
                assetCatalog: CardAssetCatalog(description: "Trace around an area repeatedly"),
                version: 0)
        }
        
        /// Contains descriptors for Movement/Relative cards
        public struct Relative {
            private init() {}
            
            //MARK: Movement/Relative/Follow
            public static let Follow = ActionCardDescriptor(
                name: "Follow",
                subpath: "Movement/Relative",
                inputs: [
                    InputSlot(name: "Object", type: .Coordinate2D, isOptional: false),
                    InputSlot(name: "Distance", type: .SwiftDouble, isOptional: false),
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: false,
                endsDescription: nil,
                assetCatalog: CardAssetCatalog(description: "Follow an object"),
                version: 0)
        }
        
        /// Contains descriptors for Movement/Simple cards
        public struct Simple {
            private init() {}
            
            //MARK: Movement/Simple/FlyForward
            public static let FlyForward = ActionCardDescriptor(
                name: "Fly Forward",
                subpath: "Movement/Simple",
                inputs: [
                    InputSlot(name: "Distance", type: .SwiftDouble, isOptional: false),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: true,
                endsDescription: "Ends when the drone has flown the specified distance",
                assetCatalog: CardAssetCatalog(description: "Fly forward"),
                version: 0)
            
            //MARK: Movement/Simple/Hover
            public static let Hover = ActionCardDescriptor(
                name: "Hover",
                subpath: "Movement/Simple",
                inputs: [
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: false,
                endsDescription: nil,
                assetCatalog: CardAssetCatalog(description: "Hover in the air"),
                version: 0)
            
            //MARK: Movement/Simple/Land
            public static let Land = ActionCardDescriptor(
                name: "Land",
                subpath: "Movement/Simple",
                inputs: [
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: true,
                endsDescription: "Ends when the drone has landed",
                assetCatalog: CardAssetCatalog(description: "Land"),
                version: 0)
        }
        
        /// Contains descriptors for Movement/Sequence cards
        public struct Sequence {
            private init() {}
            
            //MARK: Movement/Sequence/FlyPath
            public static let FlyPath = ActionCardDescriptor(
                name: "Fly Path",
                subpath: "Movement/Sequence",
                inputs: [
                    InputSlot(name: "Path", type: .Coordinate2DPath, isOptional: false),
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: true,
                endsDescription: "Ends when the drone has flown the path",
                assetCatalog: CardAssetCatalog(description: "Fly path"),
                version: 0)
            
            //MARK: Movement/Sequence/Pace
            public static let Pace = ActionCardDescriptor(
                name: "Pace",
                subpath: "Movement/Sequence",
                inputs: [
                    InputSlot(name: "Path", type: .Coordinate2DPath, isOptional: false),
                    InputSlot(name: "Altitude", type: .SwiftDouble, isOptional: true),
                    InputSlot(name: "Speed", type: .SwiftDouble, isOptional: true)
                ],
                tokens: [
                    TokenSlot(name: "Drone", descriptor: DroneCards.Token.Drone)
                ],
                yields: nil,
                yieldDescription: nil,
                ends: false,
                endsDescription: nil,
                assetCatalog: CardAssetCatalog(description: "Pace forwards and backwards along the path"),
                version: 0)
        }
    }
    
    public struct Modifier {
        private init() {}
        private static let _class = CardPath(parent: _root, label : "Modifier")
        
        public struct Movement {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Movement")
            
            public static let Altitude : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Altitude",
                parameter: Double.self)
            public static let AngularSpeed : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Angular Speed",
                parameter: Double.self)
            public static let Avoid : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Avoid",
                parameter: InputCoordinate2DPath.self)
            public static let Speed : InputCardDesc = InputCardDesc(
                path: _subclass,
                name: "Speed",
                parameter: Double.self)
        }
    }
    
    public struct Tech {
        private init() {}
        private static let _class = CardPath(parent: _root, label : "Tech")
        
        public struct Camera {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Camera")
            
            public static let RecordVideo : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Record Video",
                ends: false,
                tokens: ["camera" : Token.Camera])
            public static let TakeAPhoto : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Take a Photo",
                ends: true,
                tokens: ["camera" : Token.Camera])
            public static let TakePhotos : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Take Photos",
                ends: false,
                tokens: ["camera" : Token.Camera])
        }
        
        public struct Claw {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Claw")
            
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
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Gimbal")
            
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
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Sensor")
            
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
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Speaker")
            
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
        private init() {}
        private static let _class = CardPath(parent: _root, label : "Think")
        
        public struct Find {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Find")
            
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
        private init() {}
        private static let _class = CardPath(parent: _root, label : "Trigger")
        
        public struct Movement {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Movement")
            
            public static let WaitUntilLocation : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Wait until Location",
                ends: true,
                mandatoryInputs: ["location" : BaseCardDescs.Input.Location.Location])
            
        }
        
        public struct Tech {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Tech")
            
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
        private init() {}
        private static let _class = CardPath(parent: _root, label : "Token")
        
        public static let Movement = TokenCardDesc(
            path: _class,
            name: "Movement",
            consumed: true)
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
        public static let Camera = TokenCardDesc(
            path: _class,
            name: "Camera",
            consumed: true)
        public static let Camera_Read_Only = TokenCardDesc(
            path: _class,
            name: "Camera",
            consumed: false)
        public static let Claw = TokenCardDesc(
            path: _class,
            name: "Claw",
            consumed: true)
        public static let Gimbal = TokenCardDesc(
            path: _class,
            name: "Gimbal",
            consumed: true)
        public static let Speaker = TokenCardDesc(
            path: _class,
            name: "Speaker",
            consumed: true)
    }
}
