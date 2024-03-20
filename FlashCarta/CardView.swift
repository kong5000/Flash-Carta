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
    
    let card: Card
    var removal: ((Difficulty) -> Void)? = nil
    
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
                    Text("Edit")
                }
                Spacer()
                Button {
                    SoundUtility.speak(card: card)
                    
                } label: {
                    Image(systemName: "speaker.wave.2.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                }.padding()
                Text(card.word)
                    .font(.largeTitle)
                    .foregroundStyle(Theme.secondary)
                
                
                Text(card.definition)
                    .font(.title)
                    .foregroundStyle(Theme.dark)
                    .opacity(isShowingAnswer ? 1.0 : 0)
                    .padding()
                
                
                Spacer()
                
            }
            .foregroundColor(Theme.secondary)
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(height:450)
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
                isShowingAnswer.toggle()
            }
        }
    }
}

