//
//  DataController.swift
//  FlashCard
//
//  Created by k on 2024-03-19.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "Model")
    
    init(){
        container.loadPersistentStores { desc, error in
            if let error {
                print("Fade to load data \(error.localizedDescription)")
            }
            let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
            do {
                let result = try self.container.viewContext.fetch(fetchRequest)
                if(result.isEmpty){
                    self.preloadData()
                }
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
    
    func updateCard(card: Card, nextReview: Date, context: NSManagedObjectContext){
        card.nextReview = nextReview
        save(context: context)
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
                    card.rank = Int64(columns[0]) ?? -1
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
}
