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

import CardKitRuntime

public class PanBetweenLocations: ExecutableAction {
    override public func main() {
        guard let telemetry: TelemetryToken = self.token(named: "Telemetry") as? TelemetryToken,
            let gimbal: GimbalToken = self.token(named: "Gimbal") as? GimbalToken,
            let startLocation: DCKCoordinate3D = self.value(forInput: "StartLocation"),
            let endLocation: DCKCoordinate3D = self.value(forInput: "EndLocation")
            else { return }
        
        let duration: Double? = self.optionalValue(forInput: "Duration")
        
        // rotate to the start location
        var coordinate: DCKCoordinate3D = startLocation
        
        // pan between locations until we are finished executing
        while !self.isCancelled {
            // get the current location of the drone
            guard let currentLocation = telemetry.currentLocation,
                let currentAltitude = telemetry.currentAltitude,
                let currentAttitude = telemetry.currentAttitude else {
                    self.error(DroneTokenError.failureRetrievingDroneState)
                    return
            }
            
            // make an oriented 3D coordinate for the drone's location
            let droneLocation = DCKOrientedCoordinate3D(latitude: currentLocation.latitude, longitude: currentLocation.longitude, altitude: currentAltitude, yaw: currentAttitude.yaw)
            
            // calculate the bearing between the drone and the coordinate
            let yaw = droneLocation.bearing(to: coordinate)
            
            // calculate the pitch angle needed to orient the gimbal to the coordinate
            let pitch = droneLocation.asNonOriented().pitch(to: coordinate)
            
            // rotate the gimbal
            do {
                if !self.isCancelled {
                    if let duration = duration {
                        try gimbal.rotate(yaw: yaw, pitch: pitch, roll: nil, relative: false, withinTimeInSeconds: duration)
                    } else {
                        try gimbal.rotate(yaw: yaw, pitch: pitch, roll: nil, relative: false, withinTimeInSeconds: nil)
                    }
                }
            } catch {
                self.error(error)
                
                if !self.isCancelled {
                    self.cancel()
                }
            }
            
            // set up for the other coordinate
            coordinate = (coordinate == startLocation) ? endLocation : startLocation
        }
    }
    
    override public func cancel() {}
}
