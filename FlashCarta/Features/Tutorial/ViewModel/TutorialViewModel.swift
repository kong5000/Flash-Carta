//
//  ExerciseViewModel.swift
//  FlashCard
//
//  Created by k on 2024-03-18.
//

import Foundation
import SwiftUI

struct TutorialCard {
    var exampleTranslation: String
    var example: String
    var animation: String?
    var word: String
    var rank: Int64
    var definition: String
    var systemImage: String?

}



class TutorialViewModel: ObservableObject {
    @AppStorage("firstTimeUser") private var firstTimeUser = true

    @Published var exerciseCards = [TutorialCard]()
    @Published var exerciseComplete = false
    @Published var levelProgress = 1.0
    
    init(){
        SoundUtility.preloadSpeechSynthesizer()
    }
    
    func loadCards(){
        self.exerciseCards = [
            TutorialCard(exampleTranslation: "", example: "", word: "Cards are provided in order of frequency in spoken and written language", rank: 5, definition: "The cards will be presented using spaced repetion until mastery",  systemImage: "arrowshape.right.fill"),
            TutorialCard(exampleTranslation: "", example: "", word: "Tape me to flip", rank: 4, definition: "The spaced repetition algorithm will show you a card less and less often depening on your mastery", systemImage: "arrowshape.right.fill"),
            TutorialCard(exampleTranslation: "", example: "", word: "Tap me to flip", rank: 3, definition: "If you hade moderate difficulty swipe the card down", systemImage: "arrowshape.down.fill"),
            TutorialCard(exampleTranslation: "", example: "", word: "Tap me to flip", rank: 2, definition: "If a card was difficult to recall swipe the card left", systemImage: "arrowshape.left.fill"),
            TutorialCard(exampleTranslation: "", example: "", word: "Tap me to flip", rank: 1, definition: "If a word was easy to recall swipe the card right", systemImage: "arrowshape.right.fill"),
        ]
    }
    
    @MainActor
    func handleCard(difficulty: Difficulty, card: TutorialCard, index: Int){
        exerciseCards.remove(at: index)
        
        if exerciseCards.count < 1 {
            exerciseComplete = true
            firstTimeUser = false
        }
    }
}
