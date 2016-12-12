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
        
        drone.land().then { _ in
            drone.motors(spinning: false)
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
        
        drone.areMotorsOn().then(execute: { (result) -> Promise<Void> in
            if result {
                return drone.hover(withYaw: nil)
            }
            
            return Promise<Void>.empty(result: ())
        }).catch(execute: { _ in
            // not sure how to handle an error with continuing to hover
            // we can't land because land either failed or cancel was called on this operation
        })
    }
}
