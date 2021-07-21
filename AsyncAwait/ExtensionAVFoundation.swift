//
//  ExtensionAVFoundation.swift
//  AsyncAwait
//
//  Created by jeevan tiwari on 6/17/21.
//

import Foundation
import AVFoundation
import Speech
var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("ERROR")
        }
    }
}

func requestTranscribePermissions(completion: @escaping (String) -> Void) {
    SFSpeechRecognizer.requestAuthorization { authStatus in
        DispatchQueue.main.async {
            if authStatus == .authorized {
                print("Good to go!")
                if let path = Bundle.main.path(forResource: "music", ofType: "mp3") {
                    do {
                        transcribeAudio(url: URL(fileURLWithPath: path), completion: completion)
                    } catch {
                        print("ERROR")
                    }
                }
            } else {
                print("Transcription permission was declined.")
            }
        }
    }
}

func transcribeAudio(url: URL, completion: @escaping (String) -> Void) {
    // create a new recognizer and point it at our audio
    let recognizer = SFSpeechRecognizer()
    let request = SFSpeechURLRecognitionRequest(url: url)

    // start recognition!
    recognizer?.recognitionTask(with: request) {  (result, error) in
        // abort if we didn't get any transcription back
        guard let result = result else {
            print("There was an error: \(error!)")
            return
        }

        // if we got the final transcription back, print it
        //
       // if result.isFinal {
            // pull out the best transcription...
            completion(result.bestTranscription.formattedString)
        //print(result.bestTranscription.formattedString)
            
          //  print(result.bestTranscription.formattedString)
        //}
    }
}
