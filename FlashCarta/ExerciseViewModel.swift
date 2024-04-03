//
//  ExerciseViewModel.swift
//  FlashCard
//
//  Created by k on 2024-03-18.
//

import Foundation
import CoreData
let LEVEL_DIVIDER = 50
let CARD_COUNT = 5

enum Difficulty {
    case hard, medium, easy
}

class ExerciseViewModel: ObservableObject {

//  Check if any cards are due today
    // Sort by date, get 20
        // if Less than 20 grab more by rank
    // Grab by rank to get 20
    
    
    var cards = [Card]()
    @Published var exerciseCards = [Card]()
    @Published var experience = 0
    @Published var currentExerciseXP = 0
    @Published var level = 1
    @Published var levelProgress = 0.0
    @Published var exerciseComplete = false
    
    var goodCount = 0
    var mediumCount = 0
    var hardCount = 0
    
    let container = NSPersistentContainer(name: "Model")
    
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
        }else if card.difficulty == 3 {
            return 2
        }else if card.difficulty == 9 {
            return 3
        }else if card.difficulty == 27 {
            return 4
        }else if card.difficulty > 27 {
            return 5
        }
        return 0
    }
    
    func getTotalExperience(){
        var sum = 0
        for card in self.cards {
            sum += calculateExperience(card: card)
        }
        self.experience = sum
        
        self.level = self.experience / LEVEL_DIVIDER + 1
        self.levelProgress = Double(self.experience % LEVEL_DIVIDER)
    }
            

    func save(context: NSManagedObjectContext){
        do{
            try context.save()
        }catch{
            print("Error saving data")
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
                    card.rank = Int64(Int(columns[0]) ?? -1)
                    card.word = columns[1]
                    card.partOfSpeech = columns[2]
                    card.definition = columns[3]
                    card.example = columns[4]
     
                    card.exampleTranslation = columns[5]
                    if columns.count > 6 {
                        card.animation = columns[6]
                    }

                    save(context: container.viewContext)
                }
            }
        }catch{
            //Throw, app wont work if this fails
        }
    }
    
    func dueCards() -> [Card] {
        let due = cards.filter{
            if let date = $0.nextReview {
                return date <= Date()
            }
            return false
        }
        return due
    }
    
    func unseenCards() -> [Card]{
        let unseen = cards.filter{
            if $0.nextReview == nil {
                return true
            }
            return false
        }
        return unseen
    }
    
    
    
    func nonDueCards() -> [Card]{
        let nonDue = cards.filter{
            if let date = $0.nextReview {
                return date > Date()
            }
            return false
        }
        return nonDue
    }
    
    
    func getCards(count: Int = CARD_COUNT){
        goodCount = 0
        mediumCount = 0
        hardCount = 0
        self.exerciseComplete = false
        self.currentExerciseXP = 0
        self.getTotalExperience()

        let dueCards = dueCards()
        let nonDueCards = nonDueCards()
        let unseenCards = unseenCards()
        print("due cards", dueCards.count)
        print("non due cards", nonDueCards.count)
        print("unseen cards", unseenCards.count)

        //If there are enough due cards, return them
        if dueCards.count >= CARD_COUNT {
            self.exerciseCards = Array(dueCards[0..<CARD_COUNT])
        }else{
            var cardsToDraw = CARD_COUNT - dueCards.count
            //Not enough cards are due, draw some unseencards
            if unseenCards.count >= cardsToDraw {
                self.exerciseCards = unseenCards[0..<cardsToDraw] + dueCards
            }else{
                //Not enough unseen cards left, draw from the non due cards
                cardsToDraw = CARD_COUNT - unseenCards.count - dueCards.count
                self.exerciseCards = (Array(nonDueCards[0..<cardsToDraw]) + unseenCards + dueCards).sorted(by: { card1, card2 in
                    return card1.rank > card2.rank
                })
            }
        }
    }
    
    @MainActor
    func handleCard(difficulty: Difficulty, card: Card, index: Int){
        let oldExperience = calculateExperience(card: card)
        switch difficulty {
            case .easy:
                if card.difficulty == 0 {
                    card.difficulty = 3
                }else{
                    card.difficulty = card.difficulty * 3
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
        }
    }
}
