//
//  ExerciseViewModel.swift
//  FlashCard
//
//  Created by k on 2024-03-18.
//

import Foundation
import CoreData
import SwiftUI

let LEVEL_DIVIDER = 50

enum Difficulty {
    case hard, medium, easy
}

struct Result: Identifiable {
    let id = UUID()
    let title: String
    let count: Int
    let color: Color
}

class ExerciseViewModel: ObservableObject {
    @AppStorage("repetitionFactor") private var repetitionFactor = 3
    @AppStorage("cardsPerExercise") private var cardsPerExercise = 5

    var cards = [Card]()
    @Published var exerciseCards = [Card]()
    @Published var experience = 0
    @Published var currentExerciseXP = 0
    @Published var level = 1
    @Published var levelProgress = 0.0
    @Published var exerciseComplete = false
    var availableCards = [Card]()
    
    var goodCount = 0
    var mediumCount = 0
    var hardCount = 0
    
    @Published var results = [Result]()

    
    let container = CoreDataManager.shared.persistentContainer
    
    init(){
        SoundUtility.preloadSpeechSynthesizer()
        container.loadPersistentStores { desc, error in
            if let error {
                print("Fade to load data \(error.localizedDescription)")
            }
            self.loadCards()
            self.getTotalExperience()
        }
    }
    
    func loadCards(){
        do{
            let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
            var result = try self.container.viewContext.fetch(fetchRequest)
            if(result.isEmpty){
                self.preloadData()
                result = try self.container.viewContext.fetch(fetchRequest)
            }

            self.cards = result
        }catch{
            print("Error fetching data: \(error)")
        }
    }
    
    func calculateExperience(card: Card) -> Int{
        if card.difficulty == 1 {
            return 1
        }else if card.difficulty == repetitionFactor {
            return 2
        }else if card.difficulty == Int(pow(Double(repetitionFactor),2)) {
            return 3
        }else if card.difficulty == Int(pow(Double(repetitionFactor),3)) {
            return 4
        }else if card.difficulty > Int(pow(Double(repetitionFactor),2)) {
            return 5
        }
        return 0
    }
    
    func getTotalExperience(){
        var sum = 0
        for card in self.cards {
            sum += calculateExperience(card: card)
        }
        print(sum)
        print()
    
        self.experience = sum
        
        self.level = self.experience / LEVEL_DIVIDER + 1
        self.levelProgress = Double(self.experience % LEVEL_DIVIDER)
    }
            

    func save(context: NSManagedObjectContext){
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    func updateCard(card: Card, nextReview: Date){
        card.nextReview = nextReview
        save(context: container.viewContext)
    }
    
    
    func fetchData () -> [Card] {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        do {
            var result = try container.viewContext.fetch(fetchRequest)
            if(result.isEmpty){
                preloadData()
                result = try container.viewContext.fetch(fetchRequest)
            }
            return result
        } catch {
            print("Error fetching data: \(error)")
            return []
        }
    }
    
    func preloadData(){
        do{
            if let filepath = Bundle.main.path(forResource: "word_list", ofType: "csv"){
                let contents = try String(contentsOfFile: filepath)
                let rows = contents.components(separatedBy: "\n")
                for row in rows {
                    let columns = row.components(separatedBy: ",")
                    let card = Card(context: container.viewContext)
                    if(columns.count <= 1){
                        continue
                    }
                    card.rank = Int64(Int(columns[0]) ?? -1)
                    card.word = columns[1]
                    card.partOfSpeech = columns[2]
                    card.definition = columns[3]
                    card.example = columns[4]
     
                    card.exampleTranslation = columns[5]
                    if columns.count > 6 {
                        card.animation = columns[6].trimmingCharacters(in: .whitespacesAndNewlines)
                    }

                    save(context: container.viewContext)
                }
            }
        }catch{
            //Throw, app wont work if this fails
        }
    }
    
    func dueCards() -> [Card] {
        print(availableCards.count)
        let due = availableCards.filter{
            if let date = $0.nextReview {
                return date <= Date()
            }
            return false
        }
        return due
    }
    
    func unseenCards() -> [Card]{
        let unseen = availableCards.filter{
            if $0.nextReview == nil && $0.rank != 0 {
                return true
            }
            return false
        }
        return unseen
    }
    
    
    
    func nonDueCards() -> [Card]{
        let nonDue = availableCards.filter{
            if let date = $0.nextReview {
                return date > Date()
            }
            return false
        }
        return nonDue
    }
    
    
    func getCards(){
        
        self.availableCards = cards.sorted(by: { a, b in
            a.rank < b.rank
        })
        
        if !UserPurchases.shared.hasPremium {
            self.availableCards = self.availableCards.filter({ card in
                card.rank < 600
            })
        }

        goodCount = 0
        mediumCount = 0
        hardCount = 0
        
        results = [Result]()
        
        self.exerciseComplete = false
        self.currentExerciseXP = 0
        self.getTotalExperience()

        let dueCards = dueCards()
        let nonDueCards = nonDueCards()

        let unseenCards = unseenCards()

        //If there are enough due cards, return them
        if dueCards.count >= cardsPerExercise {
            self.exerciseCards = Array(dueCards[0..<cardsPerExercise])
        }else{
            var cardsToDraw = cardsPerExercise - dueCards.count
            //Not enough cards are due, draw some unseencards
            if unseenCards.count >= cardsToDraw {
                self.exerciseCards = unseenCards[0..<cardsToDraw] + dueCards
            }else{
                //Not enough unseen cards left, draw from the non due cards
                cardsToDraw = cardsPerExercise - unseenCards.count - dueCards.count
                self.exerciseCards = (Array(nonDueCards[0..<cardsToDraw]) + unseenCards + dueCards)
            }
        }
    }
    
    @MainActor
    func handleCard(difficulty: Difficulty, card: Card, index: Int){
        let oldExperience = calculateExperience(card: card)
        switch difficulty {
            case .easy:
                if card.difficulty == 0 {
                    card.difficulty = Int64(repetitionFactor)
                }else{
                    card.difficulty = card.difficulty * Int64(repetitionFactor)
                }
                goodCount += 1
            case.medium:
                card.difficulty = 1
                mediumCount += 1
            case.hard:
                card.difficulty = 0
                hardCount += 1
        }
        let newExperience = calculateExperience(card: card)
        
        self.currentExerciseXP += newExperience - oldExperience
        
        let today = Date()
        let nextReviewDate = Calendar.current.date(byAdding: .day, value: Int(card.difficulty), to: today)
        exerciseCards.remove(at: index)
        updateCard(card: card, nextReview: nextReviewDate!)
        
        if exerciseCards.count < 1 {
            exerciseComplete = true
            results = [
                .init(title: "Easy", count: goodCount, color: .green),
                .init(title: "Moderate", count: mediumCount, color: .yellow),
                .init(title: "Hard", count: hardCount, color: .red)
            ]
        }
    }
    
    func resetProgress(){
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        do{
            var result = try self.container.viewContext.fetch(fetchRequest)
            for card in result {
                card.nextReview = nil
                card.difficulty = 0
            }
            
            save(context: container.viewContext)
            self.getTotalExperience()
            self.exerciseCards = [Card]()
            
        }catch{
            print(error)
        }

    }
}
