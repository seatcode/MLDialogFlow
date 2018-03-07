//
//  MockSpeechManager.swift
//  AbitAppTests
//
//  Created by Eli Kohen on 25/01/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import Foundation
@testable import MLDialogFlow

class MockSpeechManager: SpeechPermissions, SpeechToText, TextToSpeech {
    var locale: Locale = Locale.current
    
    var requestPermissionsCompletion: ((SpeechPermissionsState) -> Void)?
    var textHandler: ((String?, Error?) -> Void)?
    var stopRecognizingCalled = false
    var lastSpeakText: String?
    var speakCompletion: (() -> Void)?
    var cancelSpeakCalled = false
    
    var textHandlerError: Error?
    var textHandlerSuccess = [String]()
    
    
    func requestPermissions(completion: @escaping (SpeechPermissionsState) -> Void) {
        requestPermissionsCompletion = completion
    }
    
    func startRecognizing(textHandler: @escaping (String?, Error?) -> Void) {
        self.textHandler = textHandler
        if let error = textHandlerError {
            textHandler(nil, error)
        } else if !textHandlerSuccess.isEmpty {
            let first = textHandlerSuccess.removeFirst()
            textHandler(first, nil)
        }
    }
    
    func stopRecognizing() {
        stopRecognizingCalled = true
    }
    
    func speak(text: String, completion: (() -> Void)?) {
        lastSpeakText = text
        speakCompletion = completion
    }
    func cancelSpeak() {
        cancelSpeakCalled = true
    }
}
