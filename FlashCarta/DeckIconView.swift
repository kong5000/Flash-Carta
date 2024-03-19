//
//  DeckIconView.swift
//  FlashCard
//
//  Created by k on 2024-03-18.
//

import SwiftUI

struct DeckIconView: View {
    @State private var progress = 0.25

    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .stroke(
                        .gray,
                        lineWidth: 10
                    )
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        .black,
                        style: StrokeStyle(
                            lineWidth: 10,
                            lineCap: .round
                        )
                    )
                    .animation(.easeOut, value: progress)
                Image("book_blue")
                    .resizable()
                    .frame(width: 100, height:100)
            }
            .frame(width: 125, height:125)
            Text("1-100")
                .font(.title)
        }
    }
}

#Preview {
    DeckIconView()
}
