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

protocol CameraToken {
    func takeStillPicture(completionHandler: DroneTokenCompletionHandler?)
    func takeStillPictureSequenceStart(rate: DCKFrequency, completionHandler: DroneTokenCompletionHandler?)
    func takeStillPictureSequenceEnd(completionHandler: DroneTokenCompletionHandler?)
    
    func videoRecordStart(completionHandler: DroneTokenCompletionHandler?)
    func vidoRecordEnd(completionHandler: DroneTokenCompletionHandler?)
}
