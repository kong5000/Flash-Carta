//
//  StatsViewModel.swift
//  FlashCarta
//
//  Created by Keith Ong on 2024-04-13.
//

import Foundation
import CoreData

let PREMIUM_DECK_CUTOFF = 6

class StatsViewModel: ObservableObject {
    let container = CoreDataManager.shared.persistentContainer
    var cards: [Card] = []
    var groups: [Int:[Card]] = [:]
    
    @Published var groupProgress : [Int:Double] = [:]
    @Published var premiumProgress : [Int:Double] = [:]
    
    init() {
        self.getProgress()
    }
    
    func getProgress(){
        groups = [:]
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
                if key >= PREMIUM_DECK_CUTOFF {
                    premiumProgress[key] = Double(groupTotal) / 300.0

                }else{
                    groupProgress[key] = Double(groupTotal) / 300.0

                }
            }
            
            self.cards = result
        }catch{
            print("Error fetching data: \(error)")
        }
    }
}
