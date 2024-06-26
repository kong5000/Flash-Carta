//
//  TutorialView.swift
//  FlashCarta
//
//  Created by Keith Ong on 2024-05-05.
//

import SwiftUI

struct TutorialView: View {
    
    @StateObject private var viewModel = TutorialViewModel()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    var body: some View {
        ZStack{
//            Color(Theme.primary.opacity(0.185))
            VStack{
                Spacer()
                ZStack{
                    if !viewModel.exerciseComplete{
                        if viewModel.exerciseCards.isEmpty {
                            Button {
                                viewModel.loadCards()
                            } label: {
                                VStack{
                                    Spacer()
                                    StartIcon(progress: viewModel.levelProgress)
                                    Text("Tutorial")
                                        .font(.title2)
                                        .foregroundStyle(Theme.secondary)
                                    Spacer()
                                }
                            }
                        }
                        ForEach(0..<viewModel.exerciseCards.count, id: \.self){ index in
                            TutorialCardView(card: viewModel.exerciseCards[index]){ difficulty in
                                viewModel.handleCard(difficulty: difficulty, card: viewModel.exerciseCards[index], index: index)
                            }
                            .stacked(at: index, in: viewModel.exerciseCards.count)
                            .allowsHitTesting(index == viewModel.exerciseCards.count - 1)
                            .accessibilityHidden(index < viewModel.exerciseCards.count - 1)
                        }
                        .padding(.bottom, 70)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

