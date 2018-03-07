//
//  MockVoiceControlLanguage.swift
//  MLDialogFlow_Tests
//
//  Created by Eli Kohen Gomez on 07/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
@testable import MLDialogFlow

class MockVoiceControlLanguage: VoiceControlLanguage {
    var locale: Locale = Locale(identifier: "en-US")
    var dialogFlowLanguage: String = "en"
}
