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

public class PointInDirection: ExecutableAction {
    override public func main() {
        guard let telemetry: TelemetryToken = self.token(named: "Telemetry") as? TelemetryToken,
            let gimbal: GimbalToken = self.token(named: "Gimbal") as? GimbalToken,
            let cardinalDirection: DCKCardinalDirection = self.value(forInput: "CardinalDirection")
            else { return }
        
        guard let droneYaw = telemetry.currentAttitude?.yaw else {
            self.error(DroneTokenError.failureRetrievingDroneState)
            return
        }
        
        do {
            if !isCancelled {
                try gimbal.rotate(yaw: droneYaw.normalized() - cardinalDirection.azimuth.normalized(), pitch: nil, roll: nil, relative: false, withinTimeInSeconds: nil)
            }
        } catch let error {
            self.error(error)
            
            if !isCancelled {
                cancel()
            }
        }
    }
    
    override public func cancel() {}
}
