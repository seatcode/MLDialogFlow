//
//  VoiceControlManager.swift
//  MLDialogFlow
//
//  Created by Eli Kohen on 11/01/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import Foundation
import RxSwift
import ApiAI

private enum VoiceControlStatus {
    case idle
    case recordingVoice
    case processingText(String)
}

class VoiceControlManager: VoiceControl, LanguageProcessorDelegate {
    
    var events: Observable<VoiceControlEvent> { return eventsSubject }
    let language: VoiceControlLanguage
    
    var isMuted: Bool = false {
        didSet {
            if isMuted {
                cancelSpeak()
            }
        }
    }
    
    private let eventsSubject = PublishSubject<VoiceControlEvent>()

    private let status = Variable<VoiceControlStatus>(.idle)
    private let disposeBag = DisposeBag()

    // Speech
    private let speechPermissions: SpeechPermissions
    private let speechToText: SpeechToText
    private let textToSpeech: TextToSpeech

    // Dialog flow
    private let languageProcessor: LanguageProcessor
    
    // Configuration
    private let debounceTime: TimeInterval
    
    init(speechPermissions: SpeechPermissions,
         speechToText: SpeechToText,
         textToSpeech: TextToSpeech,
         languageProcessor: LanguageProcessor,
         language: VoiceControlLanguage,
         debounceTime: TimeInterval) {
        self.speechPermissions = speechPermissions
        self.speechToText = speechToText
        self.textToSpeech = textToSpeech
        self.language = language
        self.languageProcessor = languageProcessor
        self.debounceTime = debounceTime
        
        self.speechToText.locale = language.locale
        self.textToSpeech.locale = language.locale
        self.languageProcessor.language = language.dialogFlowLanguage
        self.languageProcessor.delegate = self
        
        bindRx()
    }
    
    func requestPermissions(completion: @escaping (Bool) -> Void) {
        
        speechPermissions.requestPermissions { state in
            completion( state == .enabled )
        }
    }
    
    func start() {
        guard status.value.isIdle else { return }
        status.value = .recordingVoice
    }
    
    func stop() {
        status.value = .idle
    }
    
    
    // MARK: - Private

    private func bindRx() {
        status.asObservable().skip(1)
            .observeOn(MainScheduler.asyncInstance)
            .subscribeNext { [weak self] status in
            switch status {
            case .idle:
                self?.stopRecognizing()
                self?.cancelSpeak()
                self?.cancelProcessing()
            case .recordingVoice:
                self?.startRecognizing()
            case let .processingText(text):
                self?.stopRecognizing()
                self?.process(text: text)
            }
        }.disposed(by: disposeBag)

        events.map { $0.recognizedText }.unwrap()
            .debounce(debounceTime, scheduler: MainScheduler.instance)
            .subscribeNext { [weak self] text in
                self?.status.value = .processingText(text)
            }.disposed(by: disposeBag)
    }

    private func handle(error: Error) {
        status.value = .idle
        send(event: .error)
    }
    
    private func send(event: VoiceControlEvent) {
        DispatchQueue.main.async {
            self.eventsSubject.onNext(event)
        }
    }


    // MARK: > Speech

    private func startRecognizing() {
        speechToText.startRecognizing { [weak self] (text, error) in
            guard let status = self?.status.value, status.isRecording else { return }
            if let text = text {
                self?.send(event: .recognizedText(text))
            } else if let _ = error {
                self?.send(event: .error)
            }
        }
    }

    private func stopRecognizing() {
        speechToText.stopRecognizing()
    }

    private func speak(text: String?, completion: (() -> Void)?) {
        guard !isMuted, let text = text else {
            completion?()
            return
        }
        textToSpeech.speak(text: text, completion: completion)
    }

    private func cancelSpeak() {
        textToSpeech.cancelSpeak()
    }


    // MARK: > Dialog flow

    private func process(text: String) {
        send(event: .processing)
        languageProcessor.process(text: text)
    }

    private func cancelProcessing() {
        languageProcessor.stopProcessingText()
        languageProcessor.clearContext()
    }
    
    
    // MARK: - LanguageProcessorDelegate
    
    func didGetIntermediateQuestion(_ text: String?) {
        send(event: .question(text))
        speak(text: text) { [weak self] in
            self?.status.value = .recordingVoice
        }
    }
    
    func didComplete(message: String?, result: AIResponseResult) {
        speak(text: message) { [weak self] in
            self?.status.value = .idle
            self?.send(event: .success(msg: message, result: result))
        }
    }
    
    func didFail(withError error: Error) {
        handle(error: error)
    }
}


private extension VoiceControlStatus {
    var isIdle: Bool {
        switch self  {
        case .idle: return true
        default: return false
        }
    }

    var isRecording: Bool {
        switch self  {
        case .recordingVoice: return true
        default: return false
        }
    }
}


private extension VoiceControlEvent {
    var recognizedText: String? {
        switch self {
        case let .recognizedText(text): return text
        default: return nil
        }
    }
}

struct DefaultVCLanguage: VoiceControlLanguage {
    var locale: Locale = Locale.autoupdatingCurrent
    var dialogFlowLanguage: String = "en"
}
