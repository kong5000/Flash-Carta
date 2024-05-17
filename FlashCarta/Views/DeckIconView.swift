//
//  DeckIconView.swift
//  FlashCard
//
//  Created by k on 2024-03-18.
//

import SwiftUI

struct DeckIconView: View {
    var progress: Double
    var label: Int
    func getLabel(label: Int) -> String {
        return String(label * 100 + 1) + "-" + String(label * 100 + 100)
    }
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .stroke(
                        Theme.dark.opacity(0.50),
                        lineWidth: 12
                    )
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Theme.secondary,
                        style: StrokeStyle(
                            lineWidth: 12,
                            lineCap: .round
                        )
                    )
                    .animation(.easeOut, value: progress)
                Image("green-book")
                    .resizable()
                    .frame(width: 80, height:80)
            }
            .padding(.bottom, 5)
            .frame(width: 130, height:130)
            Text(getLabel(label: label))
                .font(.system(size: 25))
                .bold()
                .foregroundStyle(Theme.secondary)
        }
        .padding()
    }
}
