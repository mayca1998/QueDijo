//
//  SpeechViewController.swift
//  QueDijo
//
//  Created by Maria Hernandez on 12/4/19.
//  Copyright © 2019 Maria Hernandez. All rights reserved.
//

import UIKit
import Speech
import Firebase

class SpeechViewController: UIViewController, SFSpeechRecognizerDelegate{
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "es-US"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    

    fileprivate func startRecording() throws {
        print("strat recording!!!!!")
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024,
                        format: recordingFormat) { [unowned self]
                            (buffer, _) in
                            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request) {
            [unowned self]
            (result, _) in
            if let transcription = result?.bestTranscription {
                self.speechDetected.text = transcription.formattedString
               // let wordsDetected = self.speechDetected.text as! String
               // print(wordsDetected, "!!!!!!")

            }
        }
        
    }
    
   fileprivate func stopRecording() {
        print("Stop Recording!!!!")
        //print(wordsDetected, "!!!!!!")
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
    }


    
    
    @IBAction func detectSpeech(_ sender: Any) {
        
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] (authStatus) in
            switch authStatus {
            case .authorized:
                do {
                    try self.startRecording()
                } catch let error {
                    print("There was a problem starting recording: \(error.localizedDescription)")
                }
            case .denied:
                print("Speech recognition authorization denied")
            case .restricted:
                print("Not available on this device")
            case .notDetermined:
                print("Not determined")
            }
        }
    }
    
    @IBAction func stopRec(_ sender: Any) {
        self.stopRecording()
        //dismiss(animated: true, completion: .none)

    }
    
    
    @IBOutlet weak var speechDetected: UILabel!

    @IBAction func translate(_ sender: Any) {
        let options = TranslatorOptions(sourceLanguage: .es, targetLanguage: .en)
        let translator = NaturalLanguage.naturalLanguage().translator(options: options)
        
        let wordsDetected = self.speechDetected.text as! String

      
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            translator.translate(wordsDetected) { translatedText, error in
                guard error == nil, let translatedText = translatedText else {
                    return}
                print("translation success!")
                self.speechTranslated.text = translatedText
                
                // Translation succeeded.
            }
        }
        
        
    }
    
    
    
    @IBOutlet weak var speechTranslated: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
