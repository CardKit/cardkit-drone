//
//  BaseMockToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 3/1/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import CardKit
import CardKitRuntime

public class BaseMockToken: ExecutableTokenCard {
    let prefix = ">> "
    let delay: TimeInterval = 1.0
    
    var calledFunctions: [String] = []
    
    override public init(with card: TokenCard) {
        super.init(with: card)
    }
    
    func registerFunctionCall(named name: String) {
        self.calledFunctions.append(name)
    }
}
