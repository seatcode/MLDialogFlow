//
//  ApiAiLanguageProcessor.swift
//  MLDialogFlow
//
//  Created by Eli Kohen on 25/01/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import Foundation
import ApiAI

class ApiAiLanguageProcessor: LanguageProcessor {
    
    weak var delegate: LanguageProcessorDelegate?
    var language: String = "en"

    private let incompleteActionNames: [String]
    private var resetNextContext = true

    convenience init() {
        self.init(incompleteActionNames: [])
    }

    init(incompleteActionNames: [String]) {
        self.incompleteActionNames = incompleteActionNames
    }
    
    func process(text: String) {
        ApiAI.shared().cancellAllRequests()
        
        let request = ApiAI.shared().textRequest()
        request.lang = language
        request.resetContexts = resetNextContext
        resetNextContext = false
        request.query = text
        
        request.setMappedCompletionBlockSuccess({ [weak self] (_, response) in
                guard let delegate = self?.delegate, let incompleteNames = self?.incompleteActionNames else { return }
                if response.result.actionComplete(incompleteNames: incompleteNames) {
                    delegate.didComplete(message: response.result.speech, result: response.result)
                } else {
                    delegate.didGetIntermediateQuestion(response.result.speech)
                }
            }, failure: { [weak self] (_, error) in
                self?.delegate?.didFail(withError: error)
            }
        )
        
        ApiAI.shared().enqueue(request)
    }
    
    func clearContext() {
        resetNextContext = true
    }
    
    func stopProcessingText() {
        ApiAI.shared().cancellAllRequests()
    }
}
