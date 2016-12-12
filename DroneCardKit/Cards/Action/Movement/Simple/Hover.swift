//
//  Hover.swift
//  DroneCardKit
//
//  Created by ismails on 12/7/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import PromiseKit

import CardKitRuntime

class Hover: ExecutableActionCard {
    
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        let altitudeInMeters: Double? = self.optionalValue(forInput: "Altitude")
        
        let constructedPromise: Promise<Void>
        if let meters = altitudeInMeters {
            constructedPromise = constructFlyHoverPromise(drone, altitude: DCKAltitude(metersAboveSeaLevel: meters))
        } else {
            constructedPromise = constructHoverPromise(drone)
        }
        
        constructedPromise.catch { _ in
                self.error = DroneTokenError.FailureDuringHover
                self.cancel()
        }
    }
    
    override public func cancel() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        drone.land().then { _ in
            drone.motors(spinning: false)
            }.catch { _ in
                self.error = DroneTokenError.FailureDuringLand
        }
    }
    
    private func constructFlyHoverPromise(_ droneToken: DroneToken, altitude: DCKAltitude) -> Promise<Void> {
        return droneToken.fly(to: altitude).then { _ in
            return droneToken.hover(withYaw: nil)
        }
    }
    
    private func constructHoverPromise(_ droneToken: DroneToken) -> Promise<Void> {
        return droneToken.hover(withYaw: nil)
    }
}
