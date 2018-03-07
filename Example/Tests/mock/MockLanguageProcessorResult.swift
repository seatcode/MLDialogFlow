//
//  MockAiResponseResult.swift
//  MLDialogFlow_Tests
//
//  Created by Eli Kohen Gomez on 07/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

@testable import MLDialogFlow
import Foundation

struct MockLanguageProcessorResult: LanguageProcessorResult {
    var action: String? = nil
    var speechMessages = [String]()
    var params = [String: Any]()

    init(action: String) {
        self.action = action
    }
}


extension MockLanguageProcessorResult: Equatable {
    static func ==(lhs: MockLanguageProcessorResult, rhs: MockLanguageProcessorResult) -> Bool {
        return lhs.action == rhs.action
    }
}
