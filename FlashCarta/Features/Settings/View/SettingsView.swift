//
//  SettingsView.swift
//  FlashCarta
//
//  Created by k on 2024-03-21.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("repetitionFactor") private var selectedRepetitionFactor = 3
    @AppStorage("cardsPerExercise") private var cardsPerExercise = 5

    @Binding var tabSelection: Int
    
    @State private var showConfirmation = false
    var spaceRepetitionFactor = [2,3,4,5]
    var numberOfCards = Array(1...20)
    
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
                Picker(selection:  $selectedRepetitionFactor) {
                    ForEach(spaceRepetitionFactor, id: \.self) {
                        Text("\($0)")
                    }
                } label: {
                    Text("Repetition Factor")
                }
            }
            Section{
                Button(action: {
                    print("reset progress")
                    showConfirmation = true
                }, label: {
                    Text("Reset your progress")
                })
                .confirmationDialog("Confirm Reset", isPresented: $showConfirmation, actions: {
                    Button("Confirm") {
                        print("RESET")
                    }.background(.red)
                }, message: {
                    Text("Your progress will be deleted")
                })
            }
            Section{
                Button(action: {
                    print("ACTION")
                    tabSelection = 0
                }, label: {
                    Text("View Tutorial")
                })
            }

        }
    }
}
//
//#Preview {
//    SettingsView()
//}
