//
//  SoundUtility.swift
//  FlashCarta
//
//  Created by k on 2024-03-20.
//

import Foundation
import AVFoundation

class SoundUtility {
    
    static let speechSynthesizer = AVSpeechSynthesizer()
    
    static func speak(card: Card){
        let utterance = AVSpeechUtterance(string: card.word)
        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        speechSynthesizer.speak(utterance)
    }
    
    static func preloadSpeechSynthesizer() {
        let utterance = AVSpeechUtterance(string: " ")
        utterance.volume = 0 // Make the utterance silent.
        speechSynthesizer.speak(utterance)
    }
}
