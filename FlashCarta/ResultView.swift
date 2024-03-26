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
                    HStack(alignment:.bottom,spacing: 20){
                        VStack{
                            ForEach(0..<hard, id:\.self){_ in
                                Color(.red)
                                    .frame(width: 15, height:10)
                            }
                        }
                        VStack(){
                            ForEach(0..<medium, id:\.self){_ in
                                Color(.yellow)
                                    .frame(width: 15, height:10)
                            }
                        }
                        VStack{
                            ForEach(0..<good, id:\.self){_ in
                                Color(.green)
                                    .frame(width: 15, height:10)
                            }
                        }
                    }
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
    }
}

#Preview {
    ResultView(isShowing: .constant(true), good: 10, medium: 3, hard: 2, experiencePoints: 10)
}
