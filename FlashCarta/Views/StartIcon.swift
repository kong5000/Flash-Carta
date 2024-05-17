//
//  DeckIconView.swift
//  FlashCard
//
//  Created by k on 2024-03-18.
//

import SwiftUI

struct StartIcon: View {
    var progress: Double

    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .stroke(
                        Theme.secondary,
                        lineWidth: 10
                    )
                LottieView(animationFileName: "stack_animation", loopMode: .loop)
                    .frame(width: 100, height:100)
            }
            .padding()
            .frame(width: 150, height:150)
        }
    }
}
