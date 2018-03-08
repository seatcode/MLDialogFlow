//
//  ViewController.swift
//  MLDialogFlow
//
//  Created by elikohen@gmail.com on 03/07/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import UIKit
import MLDialogFlow
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var recognizedTextLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    
    
    private lazy var voiceControl: VoiceControl = {
        return MLVoiceBuilder(dialogFlowToken: "place_your_token_here") // Dialog flow api token
            .language(MyVoiceControlLanguage()) // Object representing language. In our case spanish for voice + spanish for dialogflow
            .incompleteDFActions(["input.unknown", "some_other_incompleted_action"]) // dialog flow actions that mean "incompleted"
            .recognitionTime(1) // leave 1 second gap after last recognized voice to send and process
            .build()
    }()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bindVoiceControlEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startOrResetPressed(_ sender: Any) {
        voiceControl.requestPermissions { [weak self] permissionsGranted in
            if permissionsGranted {
                self?.voiceControl.start()
            } else {
                print("Permissions not granted! voice control cannot start")
            }
        }
    }
    
    private func bindVoiceControlEvents() {
        voiceControl.events.subscribe (onNext:  { [unowned self] event in
            switch event {
            case .error:
                print("voice control error")
            case .processing:
                print("voice control processing")
            case let .question(text):
                self.responseLabel.text = text
            case let .recognizedText(text):
                self.recognizedTextLabel.text = text
            case let .success(msg, result):
                self.responseLabel.text = msg
                print("received result: \(String(describing: result.action))")
            }
        }).disposed(by: disposeBag)
    }
}

struct MyVoiceControlLanguage: VoiceControlLanguage {
    //Locale to be used on text-to-speech voice and speech-to-text recognition
    var locale: Locale { return Locale(identifier: "es-ES") }
    //Language identifier for Dialog flow
    var dialogFlowLanguage: String { return "es" }
}
