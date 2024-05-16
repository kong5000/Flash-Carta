//
//  ResultView.swift
//  FlashCarta
//
//  Created by k on 2024-03-26.
//

import SwiftUI
import Charts

struct ResultView: View {
    @Binding var isShowing: Bool
    var good: Int
    var medium: Int
    var hard: Int
    var experiencePoints: Int
    @State private var offSet = CGSize.zero
    
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
                .fill(
                    Theme.primary
                )
                .shadow(radius: 10)
            
            ZStack {
                VStack {
                    Text(experiencePoints >= 0 ? "+\(experiencePoints) XP" :
                            "-\(abs(experiencePoints)) XP")
                    .font(.title2)
                    .foregroundStyle(Theme.secondary)
                    VStack( alignment: .leading,spacing: 20){
                        HStack{
                            ForEach(0..<hard, id:\.self){_ in
                                Color(.red)
                                    .frame(width: 15, height:10)
                            }
                        }
                        HStack(){
                            ForEach(0..<medium, id:\.self){_ in
                                Color(.yellow)
                                    .frame(width: 15, height:10)
                            }
                        }
                        HStack{
                            ForEach(0..<good, id:\.self){_ in
                                Color(.green)
                                    .frame(width: 15, height:10)
                            }
                        }
                    }
                    .frame(width: 150)
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(
                                Theme.secondary
                            )
                        
                    }
                    Button {
                        isShowing = false
                    } label: {
                        Text("Close")
                            .padding()
                    }
                }
            }
            .frame(height:40)
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
        .gesture(
            DragGesture()
                .onChanged{ gesture in
                    offSet = gesture.translation
                }
                .onEnded{ _ in
                    if abs(offSet.height) > 45 ||  abs(offSet.width) > 100{
                        isShowing = false
                    }
                    else{
                        withAnimation{
                            offSet = .zero
                        }
                    }
                }
        )
    }
}

#Preview {
    ResultView(isShowing: .constant(true), good: 3, medium: 3, hard: 2, experiencePoints: 10)
}
