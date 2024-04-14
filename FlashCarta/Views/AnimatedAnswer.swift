//
//  AnimatedCard.swift
//  FlashCarta
//
//  Created by k on 2024-04-03.
//

import SwiftUI

struct AnimatedCard: View {
    let card: Card
    @State private var playAnimation = false
    
    func playAnimationForTwoSeconds() {
        if playAnimation == true {
            return
        }
        playAnimation = true
        SoundUtility.speak(text: card.word)


        // Dispatch after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.playAnimation = false
        }
    }

    var body: some View {
        Text(card.definition)
            .font(.title)
            .foregroundStyle(Theme.dark)
            .padding()
        Spacer()
        Rectangle()
            .fill(Theme.secondary)
            .frame(height: 2)
        Spacer()
        HStack{

            LottieView(animationFileName: card.animation!, loopMode: .loop)
                .frame(width: 150, height: 150)

          
        }
        .onTapGesture {
            playAnimationForTwoSeconds()
        }

    }
    
}
