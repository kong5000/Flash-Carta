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
                    abs(offSet.height) > abs(offSet.width) ?
                        .white.opacity(1 - Double(abs(offSet.height / 50)))
                    : .white.opacity(1 - Double(abs(offSet.width / 50)))
                )
                .background(
                    abs(offSet.height) > abs(offSet.width) ?
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(.yellow)
                    : RoundedRectangle(cornerRadius: 25.0)
                        .fill(offSet.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            
            VStack{
                Text("\(offSet.height) \(offSet.width)")
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
        .rotationEffect(.degrees(Double(offSet.width / 8.0)))
        .offset(x: offSet.width * 5)
        .offset(y: offSet.height * 5)
        .opacity( abs(offSet.height) > abs(offSet.width) ?
                  2 - Double(abs(offSet.height / 50))
                  : 2 - Double(abs(offSet.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged{ gesture in
                    offSet = gesture.translation
                }
                .onEnded{ _ in
                    if abs(offSet.height) > 45 {
                        removal?()
                        print("middle")
                    }
                    else if abs(offSet.width) > 100 {
                        removal?()
                        if(offSet.width > 100){
                            print("RIght")
                        }else{
                            print("Left")
                        }
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

