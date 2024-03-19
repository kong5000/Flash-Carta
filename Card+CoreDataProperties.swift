//
//  Card+CoreDataProperties.swift
//  FlashCarta
//
//  Created by k on 2024-03-19.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var definition: String
    @NSManaged public var difficulty: Int16
    @NSManaged public var nextReview: Date?
    @NSManaged public var partOfSpeech: String
    @NSManaged public var rank: Int16
    @NSManaged public var word: String

}

extension Card : Identifiable {

}
