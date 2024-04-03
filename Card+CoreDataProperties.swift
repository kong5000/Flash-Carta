//
//  Card+CoreDataProperties.swift
//  FlashCarta
//
//  Created by k on 2024-04-03.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var definition: String
    @NSManaged public var difficulty: Int64
    @NSManaged public var nextReview: Date?
    @NSManaged public var partOfSpeech: String
    @NSManaged public var rank: Int64
    @NSManaged public var word: String
    @NSManaged public var animation: String?
    @NSManaged public var example: String
    @NSManaged public var exampleTranslation: String
    
    var separatedArray: [String] {
        let components = example.components(separatedBy: "**")
        var separatedArray: [String] = []
        for (index, component) in components.enumerated() {
            if index % 2 == 0 {
                separatedArray.append(component)
            } else {
                if index == components.count - 1 {
                    separatedArray.append(component)
                } else {
                    let subComponents = component.components(separatedBy: "**")
                    separatedArray.append(subComponents[0])
                    separatedArray.append("**\(subComponents[1])**")
                    separatedArray.append(subComponents[2])
                }
            }
        }
        return separatedArray
    }

}

extension Card : Identifiable {

}
