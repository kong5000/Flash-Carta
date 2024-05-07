//
//  DataManager.swift
//  FlashCarta
//
//  Created by Keith Ong on 2024-04-14.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // Real error handling goes here.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
