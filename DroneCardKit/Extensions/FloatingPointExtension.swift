//
//  FloatingPointExtension.swift
//  DroneCardKit
//
//  Created by ismails on 3/13/17.
//  Copyright © 2017 IBM. All rights reserved.
//

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
