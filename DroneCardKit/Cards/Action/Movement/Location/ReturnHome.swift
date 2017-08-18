//
//  ReturnHome.swift
//  DroneCardKit
//
//  Created by Kyungmin Lee on 2/7/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKitRuntime

public class ReturnHome: ExecutableAction {
    override public func main() {
        guard let drone: DroneToken = self.token(named: "Drone") as? DroneToken else { return }
        
        do {
            // return back to the home location
            if !isCancelled {
                try drone.returnHome()
            }
        } catch {
            self.error(error)
            
            if !isCancelled {
                cancel()
            }
        }
    }
    
    override public func cancel() {}
}
