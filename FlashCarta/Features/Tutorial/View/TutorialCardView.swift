import SwiftUI

struct TutorialCardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var
    accesbilityDifferentiatwWithoutColor
    
    @State private var isShowingAnswer = false
    @State private var offSet = CGSize.zero
    @State private var playAnimation = false
    
    let card: TutorialCard
    var removal: ((Difficulty) -> Void)? = nil

    func playAnimationForTwoSeconds() {
        if playAnimation == true {
            return
        }
        playAnimation = true
//        SoundUtility.speak(text: card.example)


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
                    Text("\(card.rank)")
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 30)
                    Spacer()
                    Button {
//                        SoundUtility.speak(text: card.word)
                        
                    } label: {
                        Image(systemName: "speaker.wave.2.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }.padding()
                }
                Spacer()
                Text(card.word)
                    .font(.title3)
                    .foregroundStyle(Theme.secondary)
                if isShowingAnswer {
             
                        Text(card.definition)
                            .font(.title3)
                            .foregroundStyle(Theme.dark)
                            .padding()
                        Spacer()
                        Rectangle()
                            .fill(Theme.secondary)
                               .frame(height: 2)
                        Spacer()
                    if let systemImage = card.systemImage {
                        Image(systemName: systemImage)
                            .resizable()
                            .frame(width: 100, height: 100)
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

