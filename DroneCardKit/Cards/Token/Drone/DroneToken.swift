//
//  DroneToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 9/23/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

public protocol DroneToken {
    func takeOff()
    func fly(to coordinate: DCKCoordinate2D)
    func fly(to coordinate: DCKCoordinate3D)
    func returnHome()
    func land()
}
