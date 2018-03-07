//
//  SpeechManager.swift
//  MLDialogFlow
//
//  Created by Eli Kohen on 25/01/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import Foundation
import Speech

class SpeechManager {
    
    private let audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechSynthesizer = AVSpeechSynthesizer()
    private let speechDelegate = SpeechSynthesizerDelegate()

    var locale: Locale = Locale.current {
        didSet {
            speechRecognizer = SFSpeechRecognizer(locale: locale)
        }
    }
    
    init() {
        self.speechRecognizer = SFSpeechRecognizer(locale: locale)
        
        speechSynthesizer.delegate = speechDelegate
    }
}


extension SpeechManager: SpeechPermissions {
    func requestPermissions(completion: @escaping (SpeechPermissionsState) -> Void) {
        //Requesting microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                //Request speech recognition permission
                SFSpeechRecognizer.requestAuthorization{ status in
                    DispatchQueue.main.async {
                        switch status {
                        case .authorized:
                            completion(.enabled)
                        case .notDetermined:
                            completion(.notDetermined)
                        case .denied, .restricted:
                            completion(.disabled)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.disabled)
                }
            }
        }
    }
}


extension SpeechManager: SpeechToText {
    
    func startRecognizing(textHandler: @escaping (String?, Error?) -> Void) {
        checkPermissions { [weak self] in self?.startRecording(textHandler: textHandler) }
    }
    
    func stopRecognizing() {
        cancelRecording()
    }
    
    private func checkPermissions(completion: @escaping () -> Void) {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            SFSpeechRecognizer.requestAuthorization { status in
                OperationQueue.main.addOperation {
                    switch status {
                    case .authorized:
                        completion()
                    default: break
                    }
                }
            }
        case .authorized:
            OperationQueue.main.addOperation {
                completion()
            }
        case .denied, .restricted:
            break
        }
    }
    
    private func startRecording(textHandler: @escaping (String?, Error?) -> Void) {
        cancelRecording()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        // Setup audio engine and speech recognizer
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: nil) { buffer, _ in
            request.append(buffer)
        }
        
        // Prepare and start recording
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            textHandler(nil, error)
            return
        }
        
        // Analyze the speech
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let resultText = result?.bestTranscription.formattedString, !resultText.isEmpty {
                textHandler(resultText, nil)
            } else if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    private func cancelRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
    }
}


extension SpeechManager: TextToSpeech {
    func speak(text: String, completion: (() -> Void)?) {
        speechDelegate.completion = completion
        setCorrectOutput()
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: locale.identifier)
        speechSynthesizer.speak(speechUtterance)
    }
    
    func cancelSpeak() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        speechDelegate.completion?()
        speechDelegate.completion = nil
    }
    
    private func setCorrectOutput() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.mixWithOthers, .allowBluetooth, .defaultToSpeaker])
            try audioSession.setMode(AVAudioSessionModeSpokenAudio)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
    }
}
