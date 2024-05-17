//
//  SettingsView.swift
//  FlashCarta
//
//  Created by k on 2024-03-21.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("cardsPerExercise") private var cardsPerExercise = 5
    @AppStorage("firstTimeUser") private var firstTimeUser = true
    @EnvironmentObject private var viewModel: ExerciseViewModel
    
    @Binding var tabSelection: Int
    
    @State private var showConfirmation = false
    var numberOfCards = Array(5...20)
    
    @State private var selectedFactor = 2

    var body: some View {
        Form{
            Section{
                Picker(selection:  $cardsPerExercise) {
                    ForEach(numberOfCards, id: \.self) {
                        Text("\($0)")
                    }
                } label: {
                    Text("Cards per exercise")
                }
            }
            .listRowBackground(Theme.secondary)
            .onChange(of: cardsPerExercise) { viewModel.getCards() }
            Section{
                Button(action: {
                    firstTimeUser = true
                    tabSelection = 0
                }, label: {
                    HStack{
                        Spacer()
                        Text("View Tutorial")
                        Spacer()
                    }
                })
            }
            .listRowBackground(Theme.dark)
            Section{
                Button(action: {
                    showConfirmation = true
                }, label: {
                    HStack{
                        Spacer()
                        Text("Reset Progress")
                        Spacer()
                    }
                })
                .confirmationDialog("Confirm Reset", isPresented: $showConfirmation, actions: {
                    Button("Confirm") {
                        viewModel.resetProgress()
                    }.background(.red)
                }, message: {
                    Text("Your progress will be deleted")
                })
            }
            .listRowBackground(Color.red)

        }
        .scrollContentBackground(.hidden)
    }
}

