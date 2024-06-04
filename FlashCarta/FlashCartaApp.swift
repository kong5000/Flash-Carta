//
//  FlashCartaApp.swift
//  FlashCarta
//
//  Created by Keith Ong on 2024-04-13.
//

import SwiftUI

@main
struct FlashCartaApp: App {
    
//    @StateObject private var store = DeckStore()
    
    //Need to initialize viewModel here to load initial cards into CoreData
    @StateObject private var exerciseViewModel = ExerciseViewModel()
    
    var body: some Scene {
        WindowGroup{
            ContentView()
//                .environmentObject(store)
                .environmentObject(exerciseViewModel)
        }
    }
}
