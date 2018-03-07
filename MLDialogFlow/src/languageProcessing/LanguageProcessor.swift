//
//  LanguageProcessor.swift
//  MLDialogFlow
//
//  Created by Eli Kohen on 25/01/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import Foundation
import ApiAI

public protocol LanguageProcessorDelegate: class {
    func didGetIntermediateQuestion(_ text: String?)
    func didComplete(message: String?, result: AIResponseResult)
    func didFail(withError: Error)
}

public protocol LanguageProcessor: class {
    weak var delegate: LanguageProcessorDelegate? { get set }
    var language: String { get set }
    
    func process(text: String)
    func clearContext()
    func stopProcessingText()
}
