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
               
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    ForEach(0..<viewModel.exerciseCards.count, id: \.self){ index in
                        CardView(card: viewModel.exerciseCards[index]){ difficulty in
                            withAnimation{
                                viewModel.handleCard(difficulty: difficulty, card: viewModel.exerciseCards[index], index: index)
                               
                            }
                            
                        }
                        .stacked(at: index, in: viewModel.exerciseCards.count)
                        .allowsHitTesting(index == viewModel.exerciseCards.count - 1)
                        .accessibilityHidden(index < viewModel.exerciseCards.count - 1)
                    }
                }
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
    
}

#Preview {
    ExerciseView()
}
