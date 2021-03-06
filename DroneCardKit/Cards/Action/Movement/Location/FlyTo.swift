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

public class FlyTo: ExecutableAction {
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken,
            let location: DCKCoordinate2D = self.value(forInput: "Destination")
            else { return }
        
        let altitude: DCKRelativeAltitude? = self.optionalValue(forInput: "Altitude")
        let speed: DCKSpeed? = self.optionalValue(forInput: "Speed")
        
        do {
            if !isCancelled {
                try drone.takeOff()
            }
            
            if !isCancelled {
                try drone.fly(to: location, atAltitude: altitude, atSpeed: speed)
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
