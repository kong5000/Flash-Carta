//
//  PurchaseSuccessView.swift
//  FlashCarta
//
//  Created by Keith Ong on 2024-04-18.
//

import SwiftUI

struct PurchaseSuccessView: View {
    var onClose: () -> Void
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                onClose()
            }
    }
}


