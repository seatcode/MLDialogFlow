//
//  ApiAI+Abit.swift
//  MLDialogFlow
//
//  Created by Eli Kohen Gomez on 17/01/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import Foundation
import ApiAI

class MLVoiceBuilder {

    private var dialogFlowToken: String?
    private var incompleteActions = [String]()
    private var recogniotionTime: TimeInterval = 1
    private var language: VoiceControlLanguage?

    func token(_ dfToken: String) -> MLVoiceBuilder {
        dialogFlowToken = dfToken
        return self
    }

    func language(_ language: VoiceControlLanguage) -> MLVoiceBuilder {
        self.language = language
        return self
    }

    func recognitionTime(_ time: TimeInterval) -> MLVoiceBuilder {
        self.recogniotionTime = time
        return self
    }

    func incompleteDFActions(_ actions: [String]) -> MLVoiceBuilder {
        incompleteActions = actions
        return self
    }

    func build() throws -> VoiceControl {
        guard let token = dialogFlowToken else {
            throw NSError()
        }
        let language = self.language ?? DefaultVCLanguage()

        let configuration = AIDefaultConfiguration()
        configuration.clientAccessToken = token
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
