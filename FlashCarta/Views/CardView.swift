//
//  CardView.swift
//  FlashCard
//
//  Created by k on 2024-03-14.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var
    accesbilityDifferentiatwWithoutColor
    
    @State private var isShowingAnswer = false
    @State private var offSet = CGSize.zero
    @State private var playAnimation = false
    
    let card: Card
    var removal: ((Difficulty) -> Void)? = nil

    func playAnimationForTwoSeconds() {
        if playAnimation == true {
            return
        }
        playAnimation = true
        SoundUtility.speak(text: card.example)


        // Dispatch after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.playAnimation = false
        }
    }

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
                .fill(
                    abs(offSet.height) > abs(offSet.width) ?
                    Theme.primary.opacity(1 - Double(abs(offSet.height / 50)))
                    : Theme.primary.opacity(1 - Double(abs(offSet.width / 50)))
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
                HStack{
                    Text("Rank \(card.rank)")
                        .bold()
                    Spacer()
                    Text("Noun")
                    Spacer()
                    Button {
                        SoundUtility.speak(text: card.word)
                        
                    } label: {
                        Image(systemName: "speaker.wave.2.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }.padding()
                }
                Spacer()
                Text(card.word)
                    .font(.largeTitle)
                    .foregroundStyle(Theme.secondary)
                if isShowingAnswer {
                    if let animation = card.animation {
                        AnimatedCard(card: card)
                    }else{
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
                            LottieButton(isPlaying: $playAnimation, animationFileName: "wired-flat-693-singer-vocalist")
                                .frame(width: 120, height:120)
                      
                            VStack(alignment: .leading){
                                Text(.init(card.example))
                                    .font(.subheadline)
                                    .padding(12)
                                    .background(Theme.secondary)
                                    .foregroundStyle(Theme.dark)
                                    .clipShape(ChatBubble(top: true))
                                Text(.init(card.exampleTranslation))
                                    .font(.subheadline)
                                    .padding(12)
                                    .background(Theme.dark)
                                    .foregroundStyle(Theme.secondary)
                                    .clipShape(ChatBubble(top: false))
                            }
                            .padding()
                        }
                        .onTapGesture {
                            playAnimationForTwoSeconds()
                        }
                    }
 
                }
                
                
                Spacer()
                
            }
            .foregroundColor(Theme.secondary)
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(height:475)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Theme.secondary, lineWidth: 4)
        )
        .padding()
        .rotationEffect(.degrees(Double(offSet.width / 8.0)))
        .offset(x: offSet.width * 5)
        .offset(y: offSet.height * 5)
        .opacity( abs(offSet.height) > abs(offSet.width) ?
                  2 - Double(abs(offSet.height / 50))
                  : 2 - Double(abs(offSet.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            isShowingAnswer ?
            DragGesture()
                .onChanged{ gesture in
                    offSet = gesture.translation
                }
                .onEnded{ _ in
                    if abs(offSet.height) > 45 {
                        removal?(.medium)
                        print("middle")
                    }
                    else if abs(offSet.width) > 100 {
                        if(offSet.width > 100){
                            removal?(.easy)
                        }else{
                            removal?(.hard)
                        }
                    }else{
                        withAnimation{
                            offSet = .zero
                        }
                    }
                }
            : nil
        )
        .onTapGesture {
            if(!isShowingAnswer){
                withAnimation {
                    isShowingAnswer.toggle()
                }
            }
        }
    }
    

}

