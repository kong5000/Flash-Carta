//
//  ContentView.swift
//  FlashCarta
//
//  Created by k on 2024-03-19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack{
                Theme.primary
                    .ignoresSafeArea()
                    .opacity(0.85)
                TabView{
                    ExerciseView()
                        .tabItem {
                            Label("", systemImage: "square.stack.fill")
                        }
                    ProgressView()
                        .tabItem {
                            Label("", systemImage: "chart.pie.fill")
                        }
                    SettingsView()
                        .tabItem {
                            Label("", systemImage: "gearshape")
                        }
                }.accentColor(Theme.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
}
