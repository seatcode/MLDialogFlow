//
//  ApiAI+Abit.swift
//  MLDialogFlow
//
//  Created by Eli Kohen Gomez on 17/01/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import Foundation
import ApiAI

public class MLVoiceBuilder {

    private let dialogFlowToken: String
    private var incompleteActions = [String]()
    private var recogniotionTime: TimeInterval = 1
    private var language: VoiceControlLanguage?
    
    public init(dialogFlowToken: String) {
        self.dialogFlowToken = dialogFlowToken
    }

    public func language(_ language: VoiceControlLanguage) -> MLVoiceBuilder {
        self.language = language
        return self
    }

    public func recognitionTime(_ time: TimeInterval) -> MLVoiceBuilder {
        self.recogniotionTime = time
        return self
    }

    public func incompleteDFActions(_ actions: [String]) -> MLVoiceBuilder {
        incompleteActions = actions
        return self
    }

    public func build() -> VoiceControl {
        let language = self.language ?? DefaultVCLanguage()

        let configuration = AIDefaultConfiguration()
        configuration.clientAccessToken = dialogFlowToken
        ApiAI.shared().configuration = configuration

        let speechManager = SpeechManager()
        let languageProcessor = ApiAiLanguageProcessor(incompleteActionNames: incompleteActions)

        return VoiceControlManager(speechPermissions: speechManager,
                                   speechToText: speechManager,
                                   textToSpeech: speechManager,
                                   languageProcessor: languageProcessor,
                                   language: language,
                                   debounceTime: recogniotionTime)
    }
}
