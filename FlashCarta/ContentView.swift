//
//  ContentView.swift
//  FlashCarta
//
//  Created by k on 2024-03-19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack{
                Theme.primary
                    .ignoresSafeArea()
                    .opacity(0.85)
       
                VStack{

                    VStack{
     
                        NavigationLink {
                            ExerciseView()
                        } label: {
                            VStack{
                                LottieView(animationFileName: "stack_animation", loopMode: .loop)
                                           .frame(width: 100, height: 100)
                                Text("Learn")
                            }
                
                        }
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
    }
}

#Preview {
    ContentView()
}
