//
//  Land.swift
//  DroneCardKit
//
//  Created by ismails on 12/7/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import PromiseKit

import CardKitRuntime

class Land: ExecutableActionCard {
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        let _: Double? = self.optionalValue(forInput: "Speed")
        
        firstly {
            drone.land()
        }.then {
            drone.turnMotorsOff()
        }.catch { _ in
            self.error = DroneTokenError.FailureDuringLand
            self.cancel()
        }
    }
    
    override public func cancel() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        if let isOn = drone.areMotorsOn, isOn {
            drone.hover().catch { _ in
                self.error = DroneTokenError.FailureDuringLand
            }
        }
    }
}
