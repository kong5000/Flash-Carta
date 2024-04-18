//
//  TestVIew.swift
//  FlashCarta
//
//  Created by Keith Ong on 2024-04-18.
//

import SwiftUI
import StoreKit

struct TestVIew: View {
    @State private var myProduct: Product?
    
    var body: some View {
        VStack{
            Text("Hello, World!")
            Text(myProduct?.displayName ?? "")
            Text(myProduct?.description ?? "")
            Text(myProduct?.displayPrice ?? "")

        }
        .task {
            myProduct = try? await Product.products(for: ["keith.FlashCarta.extendedDecks"]).first
        }
    }
}

#Preview {
    TestVIew()
}
