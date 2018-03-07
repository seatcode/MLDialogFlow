//
//  VoiceControlManagerSpec.swift
//  AbitAppTests
//
//  Created by Eli Kohen on 25/01/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

@testable import MLDialogFlow
import Foundation
import Quick
import Nimble
import RxSwift
import RxTest

class VoiceControlManagerSpec: QuickSpec {
    
    override func spec() {
        var sut: VoiceControlManager!
        var speechManager: MockSpeechManager!
        var languageProcessor: MockLanguageProcessor!
        var language: MockVoiceControlLanguage!
        
        var disposeBag: DisposeBag!
        var events: TestableObserver<VoiceControlEvent>!
        
        var requestPermissionsResult: Bool?
        let requestPermissionsCompletion: (Bool) -> Void = { result in
            requestPermissionsResult = result
        }
        
        describe("VoiceControlManagerSpec") {
            
            beforeEach {
                speechManager = MockSpeechManager()
                languageProcessor = MockLanguageProcessor()
                language = MockVoiceControlLanguage()

                disposeBag = DisposeBag()
                let scheduler = TestScheduler(initialClock: 0)
                scheduler.start()
                events = scheduler.createObserver(VoiceControlEvent.self)
            }
            
            func buildSut() {
                sut = VoiceControlManager(speechPermissions: speechManager,
                                          speechToText: speechManager,
                                          textToSpeech: speechManager,
                                          languageProcessor: languageProcessor,
                                          language: language,
                                          debounceTime: 0.1)
                sut.events.subscribe(events).disposed(by: disposeBag)
            }
            
            afterEach {
                requestPermissionsResult = nil
                disposeBag = DisposeBag()
                print("after each")
            }
            
            describe("permissions") {
                beforeEach {
                    buildSut()
                    sut.requestPermissions(completion: requestPermissionsCompletion)
                }
                context("disabled") {
                    beforeEach {
                        speechManager.requestPermissionsCompletion?(.disabled)
                    }
                    it("sends false to callback") {
                        expect(requestPermissionsResult) == false
                    }
                }
                context("notDetermined") {
                    beforeEach {
                        speechManager.requestPermissionsCompletion?(.notDetermined)
                    }
                    it("sends false to callback") {
                        expect(requestPermissionsResult) == false
                    }
                }
                context("disabled") {
                    beforeEach {
                        speechManager.requestPermissionsCompletion?(.enabled)
                    }
                    it("sends true to callback") {
                        expect(requestPermissionsResult) == true
                    }
                }
            }
            describe("language") {
                context("english") {
                    beforeEach {
                        buildSut()
                    }
                    it("configures speech manager correctly") {
                        expect(speechManager.locale.identifier) == "en-US"
                    }
                    it("configures languageProcessor correctly") {
                        expect(languageProcessor.language) == "en"
                    }
                }
                context("spanish") {
                    beforeEach {
                        language.locale = Locale(identifier: "es-ES")
                        language.dialogFlowLanguage = "es"
                        buildSut()
                    }
                    it("configures speech manager correctly") {
                        expect(speechManager.locale.identifier) == "es-ES"
                    }
                    it("configures languageProcessor correctly") {
                        expect(languageProcessor.language) == "es"
                    }
                }
            }
            describe("recognition") {
                beforeEach {
                    
                }
                context("valid direct phrase") {
                    beforeEach {
                        buildSut()
                        sut.isMuted = true
                        speechManager.textHandlerSuccess = ["show only pharmacies"]
                        languageProcessor.processSuccess = ("showing only pharmacies", MockLanguageProcessorResult(action: "test"))
                        sut.start()
                    }
                    it("gets correct event flow") {
                        let eventsValues: [VoiceControlEvent] = [.recognizedText("show only pharmacies"), .processing, .success(msg: "showing only pharmacies", result: MockLanguageProcessorResult(action: "test"))]
                        expect(events.elements).toEventually(equal(eventsValues), timeout: 5, pollInterval: 0.1, description: nil)
                    }
                }
                context("question") {
                    beforeEach {
                        buildSut()
                        sut.isMuted = true
                        speechManager.textHandlerSuccess = ["show only", "pharmacies"]
                        languageProcessor.processQuestion = "Which kind of poi you want to filter for?"
                        languageProcessor.processSuccess = ("showing only pharmacies", MockLanguageProcessorResult(action: "test"))
                        sut.start()
                    }
                    it("gets correct event flow") {
                        let eventsValues: [VoiceControlEvent] = [.recognizedText("show only"),
                                                                 .processing,
                                                                 .question("Which kind of poi you want to filter for?"),
                                                                 .recognizedText("pharmacies"),
                                                                 .processing,
                                                                 .success(msg: "showing only pharmacies", result: MockLanguageProcessorResult(action: "test"))]
                        expect(events.elements).toEventually(equal(eventsValues), timeout: 5, pollInterval: 0.1, description: nil)
                    }
                }
            }
        }
    }
}
