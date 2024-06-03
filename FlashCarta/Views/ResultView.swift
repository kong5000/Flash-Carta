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
    @State private var offSet = CGSize.zero

    var results: [Result]
    var experiencePoints: Int

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
                .fill(
                    Theme.primary
                )
                .shadow(radius: 10)
            VStack {
                Text(experiencePoints >= 0 ? "+\(experiencePoints) XP" :
                        "-\(abs(experiencePoints)) XP")
                .font(.title2)
                .foregroundStyle(Theme.secondary)
                .padding(.top, 30)
                Chart(results){ result in
                    SectorMark(angle: .value(result.title, result.count),
                               innerRadius: .ratio(0.33),
                               outerRadius: .inset(20)
                    )
                    .foregroundStyle(result.color)
                }
                .padding()
                Button {
                    isShowing = false
                } label: {
                    Text("Close")
                        .foregroundStyle(Theme.secondary)
                        .font(.title3)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Theme.secondary, lineWidth: 10))
                }
                .background(Theme.primary) // If you have this
                .cornerRadius(15)
                .padding()
            }
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
    ResultView(isShowing: .constant(true), results: [
        .init(title: "Easy", count: 10, color: .green),
        .init(title: "Medium", count: 10, color: .yellow),
        .init(title: "Hard", count: 10, color: .red)],
               experiencePoints: 10)
}
