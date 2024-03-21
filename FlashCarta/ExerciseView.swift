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
    @State private var animateBackground = true
    @State private var started = false
    var body: some View {
        ZStack{
            Theme.primary
                .ignoresSafeArea()
                .opacity(0.85)
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
                    ForEach(0..<viewModel.exerciseCards.count, id: \.self){ index in
                        CardView(card: viewModel.exerciseCards[index]){ difficulty in
                                viewModel.handleCard(difficulty: difficulty, card: viewModel.exerciseCards[index], index: index)
                            
                        }
                        .stacked(at: index, in: viewModel.exerciseCards.count)
                        .allowsHitTesting(index == viewModel.exerciseCards.count - 1)
                        .accessibilityHidden(index < viewModel.exerciseCards.count - 1)
                    }
                    if viewModel.exerciseCards.isEmpty {
                        Button {
                            viewModel.getCards()

                        } label: {
                            VStack{
                                StartIcon()
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
                }
                Spacer()
            }
        }
//        .background{
//            LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
//                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//        }
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
