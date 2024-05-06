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
                Text("LVL \(viewModel.level)")
                    .font(.title)
                    .foregroundStyle(Theme.secondary)
                ProgressView(value: viewModel.levelProgress, total: Double(LEVEL_DIVIDER))
                if !viewModel.exerciseCards.isEmpty {
                    Text(viewModel.currentExerciseXP >= 0 ? "+\(viewModel.currentExerciseXP) XP" :
                            "-\(abs(viewModel.currentExerciseXP)) XP")
                    .font(.title2)
                    .foregroundStyle(Theme.secondary)
                }
                
                Spacer()
                ZStack{
                    if !viewModel.exerciseComplete{
                        if viewModel.exerciseCards.isEmpty {
                            Button {
                                viewModel.getCards()
                                
                            } label: {
                                VStack{
                                    StartIcon(progress: viewModel.levelProgress / Double(LEVEL_DIVIDER))
                                    Text("Start")
                                        .font(.title2)
                                        .foregroundStyle(Theme.secondary)
                                }
                            }
                            .onAppear{
                                withAnimation {
                                    viewModel.getTotalExperience()
                                }
                            }
                        }
                        ForEach(0..<viewModel.exerciseCards.count, id: \.self){ index in
                            CardView(card: viewModel.exerciseCards[index]){ difficulty in
                                viewModel.handleCard(difficulty: difficulty, card: viewModel.exerciseCards[index], index: index)
                                
                            }
                            .stacked(at: index, in: viewModel.exerciseCards.count)
                            .allowsHitTesting(index == viewModel.exerciseCards.count - 1)
                            .accessibilityHidden(index < viewModel.exerciseCards.count - 1)
                        }
                    }else{
                        ResultView(isShowing: $viewModel.exerciseComplete,
                                   good:viewModel.goodCount,
                                   medium: viewModel.mediumCount,
                                   hard: viewModel.hardCount,
                                   experiencePoints: viewModel.currentExerciseXP
                        )
                    }
                }
                Spacer()
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
