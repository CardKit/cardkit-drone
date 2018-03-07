/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

import CardKit
import CardKitRuntime

public struct DroneCardCatalog: DescriptorCatalog {
    /// All card descriptors included in DroneCardKit
    public let descriptors: [CardDescriptor] = [
        DroneCardKit.Action.Movement.Location.Circle,
        DroneCardKit.Action.Movement.Location.CircleRepeatedly,
        DroneCardKit.Action.Movement.Location.FlyTo,
        DroneCardKit.Action.Movement.Location.ReturnHome,
        DroneCardKit.Action.Movement.Sequence.FlyPath,
        DroneCardKit.Action.Movement.Sequence.Pace,
        DroneCardKit.Action.Movement.Simple.FlyForward,
        DroneCardKit.Action.Movement.Simple.Hover,
        DroneCardKit.Action.Movement.Simple.Land,
        DroneCardKit.Action.Tech.Camera.RecordVideo,
        DroneCardKit.Action.Tech.Camera.TakePhoto,
        DroneCardKit.Action.Tech.Camera.TakePhotoBurst,
        DroneCardKit.Action.Tech.Camera.TakePhotos,
        DroneCardKit.Action.Tech.Camera.TakeTimelapse,
        DroneCardKit.Action.Tech.Gimbal.PanBetweenLocations,
        DroneCardKit.Action.Tech.Gimbal.PointAtFront,
        DroneCardKit.Action.Tech.Gimbal.PointAtGround,
        DroneCardKit.Action.Tech.Gimbal.PointAtLocation,
        DroneCardKit.Action.Tech.Gimbal.PointInDirection,
        DroneCardKit.Input.Camera.AspectRatio,
        DroneCardKit.Input.Camera.BurstCount,
        DroneCardKit.Input.Camera.Framerate,
        DroneCardKit.Input.Camera.Resolution,
        DroneCardKit.Input.Location.Angle,
        DroneCardKit.Input.Location.BoundingBox,
        DroneCardKit.Input.Location.BoundingBox3D,
        DroneCardKit.Input.Location.CardinalDirection,
        DroneCardKit.Input.Location.Coordinate2D,
        DroneCardKit.Input.Location.Coordinate3D,
        DroneCardKit.Input.Location.Distance,
        DroneCardKit.Input.Modifier.Movement.Altitude,
        DroneCardKit.Input.Modifier.Movement.AngularVelocity,
        DroneCardKit.Input.Modifier.Movement.Speed,
        DroneCardKit.Input.Relative.RelativeToLocation,
        DroneCardKit.Input.Relative.RelativeToObject,
        DroneCardKit.Token.Camera,
        DroneCardKit.Token.Drone,
        DroneCardKit.Token.Gimbal,
        DroneCardKit.Token.Telemetry
    ]
    
    // These descriptors do not have complete implementations, so they are kept here and not (yet)
    // included in the list above.
    private let unimplementedDescriptors: [ActionCardDescriptor] = [
        DroneCardKit.Action.Movement.Area.CoverArea,
        DroneCardKit.Action.Movement.Area.Survey,
        DroneCardKit.Action.Movement.Orientation.SpinAround,
        DroneCardKit.Action.Movement.Orientation.SpinAroundRepeatedly,
        DroneCardKit.Action.Movement.Path.Trace,
        DroneCardKit.Action.Movement.Path.TraceRepeatedly,
        DroneCardKit.Action.Movement.Relative.Follow
    ]
    
    public var executableActionTypes: [ActionCardDescriptor: ExecutableAction.Type] = [
        DroneCardKit.Action.Movement.Location.Circle: Circle.self,
        DroneCardKit.Action.Movement.Location.CircleRepeatedly: CircleRepeatedly.self,
        DroneCardKit.Action.Movement.Location.FlyTo: FlyTo.self,
        DroneCardKit.Action.Movement.Location.ReturnHome: ReturnHome.self,
        DroneCardKit.Action.Movement.Sequence.FlyPath: FlyPath.self,
        DroneCardKit.Action.Movement.Sequence.Pace: Pace.self,
        DroneCardKit.Action.Movement.Simple.FlyForward: FlyForward.self,
        DroneCardKit.Action.Movement.Simple.Hover: Hover.self,
        DroneCardKit.Action.Movement.Simple.Land: Land.self,
        DroneCardKit.Action.Tech.Camera.RecordVideo: RecordVideo.self,
        DroneCardKit.Action.Tech.Camera.TakePhoto: TakePhoto.self,
        DroneCardKit.Action.Tech.Camera.TakePhotoBurst: TakePhotoBurst.self,
        DroneCardKit.Action.Tech.Camera.TakePhotos: TakePhotos.self,
        DroneCardKit.Action.Tech.Gimbal.PanBetweenLocations: PanBetweenLocations.self,
        DroneCardKit.Action.Tech.Gimbal.PointAtFront: PointAtFront.self,
        DroneCardKit.Action.Tech.Gimbal.PointAtGround: PointAtGround.self,
        DroneCardKit.Action.Tech.Gimbal.PointAtLocation: PointAtLocation.self,
        DroneCardKit.Action.Tech.Gimbal.PointInDirection: PointInDirection.self
    ]
}
