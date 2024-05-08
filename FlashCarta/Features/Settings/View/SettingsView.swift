//
//  SettingsView.swift
//  FlashCarta
//
//  Created by k on 2024-03-21.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("repetitionFactor") private var selectedRepetitionFactor = 3
    @State private var showConfirmation = false
    var spaceRepetitionFactor = [2,3,4,5]
    @State private var selectedFactor = 2

    var body: some View {
        VStack {
            HStack{
                Text("Repetition factor")
                Picker("Choose repetion factor", selection: $selectedRepetitionFactor) {
                    ForEach(spaceRepetitionFactor, id: \.self) {
                        Text("\($0)")
                    }
                }
            }
            Button(action: {
                print("reset progress")
                showConfirmation = true
            }, label: {
                Text("Reset your progress")
            })
            .confirmationDialog("Confirm Reset", isPresented: $showConfirmation, actions: {
                Button("Confirm") {
                    print("RESET")
                }
            }, message: {
                Text("Your progress will be deleted")
            })
            .onChange(of: selectedRepetitionFactor) { oldValue, newValue in
                print("UPDATE USER SETTING", oldValue, newValue)
            }
            Text("You selected: \(selectedRepetitionFactor)")
        }
    }
}

#Preview {
    SettingsView()
}
