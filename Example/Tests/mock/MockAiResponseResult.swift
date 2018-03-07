//
//  MockAiResponseResult.swift
//  MLDialogFlow_Tests
//
//  Created by Eli Kohen Gomez on 07/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ApiAI

class MockAiResponseResult: AIResponseResult {
    static func mock() -> AIResponseResult {
        return AIResponseResult()
    }
}
