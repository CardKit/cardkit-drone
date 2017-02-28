//
//  AllCards.swift
//  DroneCardKit
//
//  Returns ActionCardDescriptors of all available cards, grouped by type if requested.
//
//  Created by Kristina M Brimijoin on 2/28/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import CardKit

extension DroneCardKit {
    
    public static func allCards() -> [ActionCardDescriptor] {
        return [
            DroneCardKit.Action.Movement.Simple.FlyForward,
            DroneCardKit.Action.Movement.Simple.Hover,
            DroneCardKit.Action.Movement.Simple.Land,
            DroneCardKit.Action.Movement.Location.Circle,
            DroneCardKit.Action.Movement.Location.CircleRepeatedly,
            DroneCardKit.Action.Movement.Location.FlyTo,
            DroneCardKit.Action.Movement.Location.ReturnHome,
            DroneCardKit.Action.Movement.Sequence.FlyPath,
            DroneCardKit.Action.Movement.Sequence.Pace,
            DroneCardKit.Action.Tech.Camera.RecordVideo,
            DroneCardKit.Action.Tech.Camera.TakeHDRPhoto,
            DroneCardKit.Action.Tech.Camera.TakePhoto,
            DroneCardKit.Action.Tech.Camera.TakePhotoBurst,
            DroneCardKit.Action.Tech.Camera.TakePhotos,
            DroneCardKit.Action.Tech.Gimbal.PanBetweenLocations,
            DroneCardKit.Action.Tech.Gimbal.PointAtFront,
            DroneCardKit.Action.Tech.Gimbal.PointAtGround,
            DroneCardKit.Action.Tech.Gimbal.PointAtLocation,
            DroneCardKit.Action.Tech.Gimbal.PointAtMovement,
            DroneCardKit.Action.Tech.Gimbal.PointInDirection
        ]
    }
    
    public static func allCardsGrouped() -> [String:[ActionCardDescriptor]] {
        let cards = allCards()
        var grouped: [String: [ActionCardDescriptor]] = [:]
        
        for card in cards {
            if grouped[card.path.description] == nil {
                grouped[card.path.description] = [card]
            } else {
                grouped[card.path.description]?.append(card)
            }
        }
        return grouped
    }
}
