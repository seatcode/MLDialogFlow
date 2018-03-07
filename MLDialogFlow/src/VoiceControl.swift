//
//  VoiceControl.swift
//  MLDialogFlow
//
//  Created by Eli Kohen on 11/01/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import Foundation
import RxSwift
import ApiAI

public enum VoiceControlEvent {
    case error
    case recognizedText(String)
    case processing
    case question(String?)
    case success(msg: String?, result: AIResponseResult)
}

public protocol VoiceControlLanguage {
    var locale: Locale { get }
    var dialogFlowLanguage: String { get }
}

public protocol VoiceControl: class {
    
    var events: Observable<VoiceControlEvent> { get }
    var language: VoiceControlLanguage { get }
    
    func requestPermissions(completion: @escaping (Bool) -> Void)
    func start()
    func stop()
}
