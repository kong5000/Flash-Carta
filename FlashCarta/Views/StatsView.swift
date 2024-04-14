//
//  ProgressView.swift
//  FlashCarta
//
//  Created by k on 2024-03-21.
//

import SwiftUI

struct StatsView: View {
    @StateObject var viewModel = StatsViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack{
            ScrollView{
                Text("DECK PROGRESS")
                    .font(.title)
                    .foregroundStyle(Theme.secondary)
                    .padding()
                LazyVGrid(columns: columns){
                    ForEach(Array(viewModel.groupProgress.keys.sorted()), id: \.self){ key in
                        DeckIconView(progress: viewModel.groupProgress[key] ?? 0.0, label: key)
                    }
                }
            }
        }
        .onAppear{
            viewModel.getProgress()
        }
    }
}

#Preview {
    StatsView()
}
