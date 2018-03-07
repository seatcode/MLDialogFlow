//
//  Speech.swift
//  MLDialogFlow
//
//  Created by Eli Kohen on 25/01/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import Foundation

enum SpeechPermissionsState {
    case notDetermined, enabled, disabled
}

protocol SpeechPermissions: class {
    func requestPermissions(completion: @escaping (SpeechPermissionsState) -> Void)
}

protocol SpeechToText: class {
    var locale: Locale { get set }
    
    func startRecognizing(textHandler: @escaping (String?, Error?) -> Void)
    func stopRecognizing()
}

protocol TextToSpeech: class {
    var locale: Locale { get set }
    
    func speak(text: String, completion: (() -> Void)?)
    func cancelSpeak()
}
