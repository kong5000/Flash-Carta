//
//  ContentView.swift
//  FlashCard
//
//  Created by k on 2024-03-14.
//

import SwiftUI
import SwiftData

extension View {
    func stacked(at position: Int, in total: Int ) -> some View {
 
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct ExerciseView: View {
    @StateObject private var viewModel = ExerciseViewModel()
           
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    var body: some View {
        ZStack{
            VStack{
                Text("Time \(timeRemaining)")
                    .font(.largeTitle)
                    .padding()
                ZStack{
                    ForEach(0..<viewModel.exerciseCards.count, id: \.self){ index in
                        CardView(card: viewModel.exerciseCards[index]){
                            withAnimation{
                                removeCard(at: index)
                            }
                            
                        }
                        .stacked(at: index, in: viewModel.exerciseCards.count)
                        .allowsHitTesting(index == viewModel.exerciseCards.count - 1)
                        .accessibilityHidden(index < viewModel.exerciseCards.count - 1)
                    }
                }
            }
        }
        .onReceive(timer){ time in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase){
            if scenePhase == .active {
                isActive = true
            }else{
                isActive = false
            }
        }
    }
    
    func removeCard(at index: Int){
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)

        viewModel.updateCard(card: viewModel.exerciseCards[index], nextReview: tomorrow!)
        viewModel.exerciseCards.remove(at: index)
    }
}

#Preview {
    ExerciseView()
}
