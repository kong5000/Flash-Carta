//
//  Card+CoreDataProperties.swift
//  FlashCarta
//
//  Created by Keith Ong on 2024-05-02.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var exampleTranslation: String
    @NSManaged public var example: String
    @NSManaged public var animation: String?
    @NSManaged public var word: String
    @NSManaged public var rank: Int64
    @NSManaged public var partOfSpeech: String
    @NSManaged public var nextReview: Date?
    @NSManaged public var difficulty: Int64
    @NSManaged public var definition: String

}

extension Card : Identifiable {

}
