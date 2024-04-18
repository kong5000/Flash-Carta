//
//  FlashCartaApp.swift
//  FlashCarta
//
//  Created by Keith Ong on 2024-04-13.
//

import SwiftUI

@main
struct FlashCartaApp: App {
    
    @StateObject private var store = DeckStore()
    
    var body: some Scene {
        WindowGroup{
            ContentView()
                .environmentObject(store)
        }
    }
}
