//
//  CardView.swift
//  FlashCard
//
//  Created by k on 2024-03-14.
//

import SwiftUI
import AVFoundation

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var
        accesbilityDifferentiatwWithoutColor
    
    @State private var isShowingAnswer = false
    @State private var offSet = CGSize.zero
    let speechSynthesizer = AVSpeechSynthesizer()

    let card: Card
    var removal: (() -> Void)? = nil
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
                .fill(
                    accesbilityDifferentiatwWithoutColor
                    ? . white
                    : .white.opacity(1 - Double(abs(offSet.width / 50)))
                )
                .background(
                    accesbilityDifferentiatwWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25.0)
                        .fill(offSet.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            
            VStack{
                Text(card.nextReview?.formatted() ?? "New")
                Text(card.word)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                
                if isShowingAnswer {
                    Text(card.definition)
                        .font(.title)
                        .foregroundStyle(.secondary)
                    
                    Button("VOICE"){
                        let utterance = AVSpeechUtterance(string: card.word)
                        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
                        speechSynthesizer.speak(utterance)
                    }
                }
      
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height:250)
        .rotationEffect(.degrees(Double(offSet.width / 5.0)))
        .offset(x: offSet.width * 5)
        .opacity(2 - Double(abs(offSet.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged{ gesture in
                    offSet = gesture.translation
                }
                .onEnded{ _ in
                    if abs(offSet.width) > 100 {
                        removal?()
                    }else{
                        withAnimation{
                            offSet = .zero

                        }
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
    }
}

