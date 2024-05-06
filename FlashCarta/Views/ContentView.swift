//
//  ContentView.swift
//  FlashCarta
//
//  Created by k on 2024-03-19.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("firstTimeUser") private var firstTimeUser = true

    var body: some View {
            TabView{
                Group{
                    if(firstTimeUser){
                        TutorialView()
                            .background(Theme.primary.opacity(0.85).ignoresSafeArea())
                            .tabItem {
                                Label("", systemImage: "square.stack.fill")
                            }
                    }else{
                        ExerciseView()
                            .background(Theme.primary.opacity(0.85).ignoresSafeArea())
                            .tabItem {
                                Label("", systemImage: "square.stack.fill")
                            }
                    }
     
                    StatsView()
                        .background(Theme.primary.opacity(0.85).ignoresSafeArea())
                        .tabItem {
                            Label("", systemImage: "chart.pie.fill")
                        }
                    SettingsView()
                        .background(Theme.primary.opacity(0.85).ignoresSafeArea())
                        .tabItem {
                            Label("", systemImage: "gearshape")
                                .frame(width: 202, height: 202)
                        }
                }
                .toolbarBackground(Theme.dark.opacity(0.80), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)

            }.accentColor(Theme.secondary)
    }
}

#Preview {
    ContentView()
}
