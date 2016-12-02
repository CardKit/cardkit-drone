//
//  CameraToken.swift
//  DroneCardKit
//
//  Created by Justin Manweiler on 12/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

import CardKit
import CardKitRuntime

import PromiseKit

protocol CameraToken {
    func takeStillPicture() -> Promise<Void>
    func takeStillPictureSequenceStart(hertz: Double) -> Promise<Void>
    func takeStillPictureSequenceEnd() -> Promise<Void>
    
    func videoRecordStart() -> Promise<Void>
    func vidoRecordEnd() -> Promise<Void>
}
