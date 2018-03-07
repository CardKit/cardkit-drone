/**
 * Copyright 2018 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

import CardKit
import CardKitRuntime

public class BaseMockToken: ExecutableToken {
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
