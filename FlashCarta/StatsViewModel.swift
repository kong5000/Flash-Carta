//
//  StatsViewModel.swift
//  FlashCarta
//
//  Created by Keith Ong on 2024-04-13.
//

import Foundation
import CoreData


class StatsViewModel: ObservableObject {
    let container = NSPersistentContainer(name: "Model")
    var cards: [Card] = []
    var groups: [Int:[Card]] = [:]
    var groupProgress : [Int:Double] = [:]
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error {
                print("Fade to load data \(error.localizedDescription)")
            }
            self.loadCards()
        }
 
    }

    func loadCards(){
        do{
            let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
            var result = try self.container.viewContext.fetch(fetchRequest)
            result.forEach { card in
                let groupIndex = Int((card.rank / 100))
                if let group = groups[groupIndex] {
                    groups[groupIndex]!.append(card)
                }else{
                    groups[groupIndex] = [card]
                }
            }
        
            self.groups.forEach { (key: Int, value: [Card]) in
                var groupTotal = 0
                value.forEach { card in
                    groupTotal += Int(cbrt(Double(card.difficulty)))
                }
                groupProgress[key] = Double(groupTotal) / 300.0
                
            }
            print(groupProgress)
            self.cards = result
        }catch{
            print("Error fetching data: \(error)")
        }
    }
}
