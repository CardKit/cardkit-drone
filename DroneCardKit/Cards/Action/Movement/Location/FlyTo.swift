//
//  FlyTo.swift
//  DroneCardKit
//
//  Created by Justin Manweiler on 12/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

import PromiseKit

public class FlyTo: ExecutableActionCard {
    var promise: Promise<Any>?
    
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        guard let location: DCKCoordinate2D = self.value(forInput: "Destination") else {
            self.error = DroneTokenError.MandatoryInputAquisitionFailed
            return
        }
        
        let altitude: DCKRelativeAltitude? = self.optionalValue(forInput: "Altitude")
        let speed: DCKSpeed? = self.optionalValue(forInput: "Speed")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        print("###### >>> starting promise")
        promise = firstly {
            print("###### >>> turn motors on")
            return drone.turnMotorsOn()
            }.then {
                print("###### >>> fly to")
                return drone.fly(to: location, atYaw: nil, atAltitude: altitude, atSpeed: speed)
            }.then {
                semaphore.signal()
            }.catch {
                error in
                print("###### >>> error caught")
                self.error = DroneTokenError.FailureInFlightTriggersLand
                self.cancel()
                semaphore.signal()
        }
        
        print("###### >>> waiting on semaphore")
        semaphore.wait()
        print("###### >>> semaphore done")
    }
    
    override public func cancel() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else {
            self.error = DroneTokenError.TokenAquisitionFailed
            return
        }
        
        firstly {
            drone.land()
            }.then {
                drone.turnMotorsOff()
            }.catch {
                _ in
                if self.error == nil {
                    self.error = DroneTokenError.FailureDuringLand
                }
        }
    }
}
