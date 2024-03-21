//
//  DeckIconView.swift
//  FlashCard
//
//  Created by k on 2024-03-18.
//

import SwiftUI

struct StartIcon: View {
    var progress: Double

    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .stroke(
                        Theme.secondary,
                        lineWidth: 10
                    )
//                Circle()
//                    .trim(from: 0, to: progress)
//                    .stroke(
//                        Theme.tertiary,
//                        style: StrokeStyle(
//                            lineWidth: 10,
//                            lineCap: .round
//                        )
//                    )
//                    .animation(.easeOut.speed(0.5), value: progress)
                LottieView(animationFileName: "stack_animation", loopMode: .loop)
                    .frame(width: 100, height:100)
            }
            .padding()
            .frame(width: 150, height:150)
        }
    }
}

//#Preview {
//    StartIcon()
//}
