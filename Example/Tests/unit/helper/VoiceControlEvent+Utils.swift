//
//  VoiceControlEvent+Utils.swift
//  AbitAppTests
//
//  Created by Eli Kohen on 26/01/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import Foundation
@testable import MLDialogFlow

extension VoiceControlEvent: Equatable {
    public static func ==(lhs: VoiceControlEvent, rhs: VoiceControlEvent) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error): return true
        case (.recognizedText(let ltext), .recognizedText(let rtext)): return ltext == rtext
        case (.processing, .processing): return true
        case (.question(let ltext), .question(let rtext)): return ltext == rtext
        case (.success(let lmsg, let lresult), .success(let rmsg, let rresult)):
            return lmsg == rmsg && lresult.action == rresult.action
        default: return false
        }
    }
}
