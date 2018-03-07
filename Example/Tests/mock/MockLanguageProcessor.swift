//
//  MockLanguageProcessor.swift
//  AbitAppTests
//
//  Created by Eli Kohen on 25/01/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import Foundation
@testable import MLDialogFlow

class MockLanguageProcessor: LanguageProcessor {
    weak var delegate: LanguageProcessorDelegate?
    var language: String = "en"
    
    var lastProcessText: String?
    var clearContextCalled = false
    var stopProcessingCalled = false
    
    var processSuccess: (String?, LanguageProcessorResult)?
    var processQuestion: String?
    var processError: Error?

    func process(text: String) {
        lastProcessText = text
        if let error = processError {
            processError = nil
            delegate?.didFail(withError: error)
        } else if let question = processQuestion {
            processQuestion = nil
            delegate?.didGetIntermediateQuestion(question)
        } else if let result = processSuccess {
            processSuccess = nil
            delegate?.didComplete(message: result.0, result: result.1)
        }
    }
    func clearContext() {
        clearContextCalled = true
    }
    func stopProcessingText() {
        stopProcessingCalled = true
    }
}
