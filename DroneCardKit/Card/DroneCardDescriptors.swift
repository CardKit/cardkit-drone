import Foundation

import CardKit

public struct DroneCardDescs {
    private init() {}
    private static let _root = CardPath.Root
    
    public struct Movement {
        private init() {}
        private static let _class = CardPath(parent: _root, label : "Movement")
        
        public struct Area {
            
            private init() {}
            private static let _subclass = CardPath(parent: _class, label : "Area")
            
            public static let CoverArea : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Cover Area",
                ends: true,
                mandatoryInputs: ["area" : BaseCardDescs.Input.Location.BoundingBox],
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
            public static let Survey : ActionCardDesc  = ActionCardDesc(
                path: _subclass,
                name: "Survey",
                ends: false,
                mandatoryInputs: ["area" : BaseCardDescs.Input.Location.BoundingBox],
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
        }
        
        public struct Location {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label: "Location")
            
            public static let Circle : ActionCardDesc  = ActionCardDesc(
                path: _subclass,
                name: "Circle",
                ends: true,
                mandatoryInputs: ["center" : BaseCardDescs.Input.Location.Location, "radius" : BaseCardDescs.Input.Location.Distance],
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
            
            public static let CircleRepeatedly : ActionCardDesc  = ActionCardDesc(
                path: _subclass,
                name: "Circle Repeatedly",
                ends: false,
                mandatoryInputs: ["center" : BaseCardDescs.Input.Location.Location, "radius" : BaseCardDescs.Input.Location.Distance],
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
            
            public static let FlyTo : ActionCardDesc  = ActionCardDesc(
                path: _subclass,
                name: "Fly To",
                ends: true,
                mandatoryInputs: ["destination" : BaseCardDescs.Input.Location.Location],
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement]) { inputs, tokens in
                    let movement = tokens["drone"] as! MovementToken
                    let destination = inputs["destination"] as! InputCoordinate2D
                    
                    return SimpleActionImpl(execute: { movement.goTo(destination) }, interrupt: { movement.hover() })
                }
            
            public static let ReturnHome : ActionCardDesc  = ActionCardDesc(
                path: _subclass,
                name: "Return Home",
                ends: true,
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
        }
        
        public struct Orientation {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label: "Orientation")
            
            public static let Rotate : ActionCardDesc  = ActionCardDesc(
                path: _subclass,
                name: "Rotate",
                ends: true,
                mandatoryInputs: ["angle" : BaseCardDescs.Input.Location.Angle],
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone": Token.Movement])
            public static let SpinAround : ActionCardDesc  = ActionCardDesc(
                path: _subclass,
                name: "Spin Around",
                ends: false,
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
        }
        
        public struct Path {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label: "Path")
            
            public static let Trace : ActionCardDesc  = ActionCardDesc(
                path: _subclass,
                name: "Trace",
                ends: true,
                mandatoryInputs: ["area" : BaseCardDescs.Input.Location.BoundingBox, "offset": BaseCardDescs.Input.Location.Distance],
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
            public static let TraceRepeatedly : ActionCardDesc  = ActionCardDesc(
                path: _subclass,
                name: "Trace Repeatedly",
                ends: false,
                mandatoryInputs: ["area" : BaseCardDescs.Input.Location.BoundingBox, "offset" : BaseCardDescs.Input.Location.Distance],
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
        }

        public struct Relative {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label: "Relative")
            
            public static let Follow : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Follow",
                ends: false,
                mandatoryInputs: ["object" : BaseCardDescs.Input.Relative.RelativeToObject, "distance" : BaseCardDescs.Input.Location.Distance],
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
        }
        
        public struct Simple {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label: "Simple")
            
            public static let FlyFoward : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Fly Foward",
                ends: true,
                mandatoryInputs: ["distance" : BaseCardDescs.Input.Location.Distance],
                optionalInputs: ["speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
            public static let Hover : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Hover",
                ends: false,
                optionalInputs: ["altitude" : Modifier.Movement.Altitude],
                tokens: ["drone" : Token.Movement])
            public static let Land : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Land",
                ends: true,
                optionalInputs: ["speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
        }
        
        public struct Sequence {
            private init() {}
            private static let _subclass = CardPath(parent: _class, label: "Sequence")
            
            public static let FlyPath : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Fly Path",
                ends: true,
                mandatoryInputs: ["path" : BaseCardDescs.Input.Location.Path],
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
            public static let Pace : ActionCardDesc = ActionCardDesc(
                path: _subclass,
                name: "Pace",
                ends: false,
                mandatoryInputs: ["path" : BaseCardDescs.Input.Location.Path],
                optionalInputs: ["altitude" : Modifier.Movement.Altitude, "avoid" : Modifier.Movement.Avoid, "speed" : Modifier.Movement.Speed],
                tokens: ["drone" : Token.Movement])
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
