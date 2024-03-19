//
//  ExerciseViewModel.swift
//  FlashCard
//
//  Created by k on 2024-03-18.
//

import Foundation
import CoreData
let CARD_COUNT = 12
class ExerciseViewModel: ObservableObject {

//  Check if any cards are due today
    // Sort by date, get 20
        // if Less than 20 grab more by rank
    // Grab by rank to get 20
    
    
    var cards = [Card]()
    var exerciseCards = [Card]()
    
    let container = NSPersistentContainer(name: "Model")
    
    init(){
        container.loadPersistentStores { desc, error in
            if let error {
                print("Fade to load data \(error.localizedDescription)")
            }
            let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
            do {
                var result = try self.container.viewContext.fetch(fetchRequest)
                if(result.isEmpty){
                    self.preloadData()
                    result = try self.container.viewContext.fetch(fetchRequest)
                }
                self.cards = Array(result.prefix(12))
                self.getCards()
            } catch {
                print("Error fetching data: \(error)")
            }
        }
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
            if let filepath = Bundle.main.path(forResource: "portuguese_2500", ofType: "csv"){
                let contents = try String(contentsOfFile: filepath)
                let rows = contents.components(separatedBy: "\n")
                for row in rows {
                    let columns = row.components(separatedBy: ",")
                    let card = Card(context: container.viewContext)
                    card.rank = Int16(columns[0]) ?? -1
                    card.word = columns[1]
                    card.partOfSpeech = columns[2]
                    card.definition = columns[3]

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
        var nonDue = cards.filter{
            if let date = $0.nextReview {
                return date > Date()
            }
            return false
        }
        return nonDue
    }
    
    
    func getCards(count: Int = CARD_COUNT){
        let dueCards = dueCards()
        let nonDueCards = nonDueCards()
        let unseenCards = unseenCards()
      
        
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
                self.exerciseCards = Array(nonDueCards[0..<cardsToDraw]) + unseenCards + dueCards
            }
        }
    }
}
