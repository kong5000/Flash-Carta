//
//  ProgressView.swift
//  FlashCarta
//
//  Created by k on 2024-03-21.
//

import SwiftUI

struct StatsView: View {
    @StateObject var viewModel = StatsViewModel()
    @EnvironmentObject private var store: DeckStore
    
    @State private var showPurchaseSucces = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack{
            ScrollView{
                Text("DECK PROGRESS")
                    .font(.title)
                    .foregroundStyle(Theme.secondary)
                    .padding()
                LazyVGrid(columns: columns){
                    //TODO: UI FOR PREMIUM CARDS
                    ForEach(Array(viewModel.groupProgress.keys.sorted()), id: \.self){ key in
                        DeckIconView(progress: viewModel.groupProgress[key] ?? 0.0, label: key)
                    }
                }
                if store.purchasedItems.isEmpty {
                    ForEach(store.items){ item in
                        Button{
                            Task {
                                await store.purchase(item)
                            }
                        } label: {
                            VStack{
                                LottieView(animationFileName: "wired-flat-94-lock-unlock", loopMode: .playOnce)
                                    .frame(width: 150, height: 150)
                                Text("Unlock 600-1000")
                                    .font(.title)
                                    .foregroundStyle(Theme.secondary)
                            }
                        }
                    }
                }else{
                    LazyVGrid(columns: columns){
                        //TODO: UI FOR PREMIUM CARDS
                        ForEach(Array(viewModel.premiumProgress.keys.sorted()), id: \.self){ key in
                            DeckIconView(progress: viewModel.premiumProgress[key] ?? 0.0, label: key)
                        }
                    }
                }

  
   

            }
        }
//        .onChange(of: store.action){ action in
//            if action == .successful {
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//                    showPurchaseSucces = true
//                }
//            }
//        }
        .overlay(alignment: .bottom){
            if showPurchaseSucces {
                PurchaseSuccessView{
                    showPurchaseSucces = false
                }
            }
        }
        .onAppear{
            viewModel.getProgress()
        }
    }
}

//#Preview {
//    StatsView()
//}
