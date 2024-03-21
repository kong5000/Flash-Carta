//
//  ProgressView.swift
//  FlashCarta
//
//  Created by k on 2024-03-21.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        ZStack{
            Theme.primary
                .ignoresSafeArea()
                .opacity(0.85)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    DeckIconView()
                    DeckIconView()
                    Spacer()
                }
                HStack{
                    DeckIconView()
                    Spacer()
                    DeckIconView()
                    Spacer()
                    DeckIconView()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    StatsView()
}
