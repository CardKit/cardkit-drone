# DroneCardKit

DroneCardKit includes card definitions and implementations of drone-specific cards in the [CardKit](https://github.com/CardKit/cardkit) framework. It includes a number of new `Action`, `Input`, and `Token` cards that control a drone's movement, a camera, and a gimbal.

DroneCardKit is written in Swift 4 and supports macOS, iOS, and tvOS.

## Cards

All cards in `DroneCardKit` are specified in `DroneCardCatalog`.

### Action Cards

#### Movement

- **Circle** & **CircleRepeatedly**: these cards cause the drone to fly in a circle around a point of interest, either once or repeatedly
- **FlyTo**: causes the drone to fly to a specified GPS coordinate
- **ReturnHome**: causes the drone to return to its home (take off) location
- **FlyPath**: causes the drone to fly sequentially along the points in a path
- **Pace**: causes the drone to fly back and forth between two locations
- **FlyForward**: causes the drone to fly forward a given distance
- **Hover**: causes the drone to hover in place
- **Land**: causes the drone to land

#### Camera

- **RecordVideo**: records a video
- **TakePhoto**: takes a single photo
- **TakePhotoBurst**: takes a rapid sequence of photos
- **TakePhotos**: continuously takes photos
- **TakeTimelapse**: takes a photo timelapse

#### Gimbal

- **PanBetweenLocations**: pans the gimbal between two points
- **PointAtFront**: points the gimbal toward the front of the aircraft
- **PointAtGround**: points the gimbal downward toward the ground
- **PointAtLocation**: points the gimbal toward a specified location
- **PointInDirection**: points the gimbal in a specified direction

### Token Cards

- **Camera**: interface to a drone's camera, providing functionality for taking photos and recording videos
- **Drone**: interface to a drone, providing functionality for flying and landing
- **Gimbal**: interface to a gimbal, providing functionality for orienting the gimbal
- **Telemetry**: interface to a drone's telemetry system, used to provide information about the current location to cards that require it

### Input Cards

A number of `Input` cards are defined in DroneCardKit to provide input to the `Action` cards that control the drone, its camera, and gimbal.

## Building

DroneCardKit depends on both [CardKit](https://github.com/CardKit/cardkit) and the [CardKit Runtime](https://github.com/CardKit/cardkit-runtime). We use Carthage to manage our dependencies. Run `carthage bootstrap` to build all of the dependencies before building the DroneCardKit Xcode project.

> ⚠️ DroneCardKit does *not* provide implementations of its `Token` cards. Rather, it defines interfaces for those cards that drone-specific implementations must use. This design choice enables multiple, drone-specific token implementations to exist. For a DJI-based implementation of the `DroneCardKit` tokens, please see [DroneTokensDJI](https://github.com/CardKit/cardkit-drone-dji).

## Known Limitations

Drone cards were initially developed on paper and evaluated through a usability study. Since then, a number of new cards have been defined, some existing cards have been changed, and some have been eliminated. Thus, there are some cards lacking artwork, and artwork that may not fully match the descriptor as defined in code. In addition, `CoverArea` and `SpinAround` lack proper implementations, so their tests have been disabled.

For reference, we have included the Sketch design file for the paper drone cards in the `Resources` directory.

## Contributing

If you would like to contribute to DroneCardKit, we recommend forking the repository, making your changes, and submitting a pull request.

