//
//  Store.swift
//  FlashCarta
//
//  Created by Keith Ong on 2024-04-18.
//

import Foundation
import StoreKit

typealias PurchaseResult = Product.PurchaseResult

enum StoreErrors: Error {
    case failedVerification
}

let EXTENDED_DECK_1 = "keith.FlashCarta.extendedDecks"

class DeckStore: ObservableObject {
    
    @Published private(set) var items = [Product]()
    
    init(){
        Task{ [ weak self] in
            await self?.retrieveProducts()
        }
    }
    
    func purchase (_ item: Product) async {
        do{
            let result = try await item.purchase()
            try await handlePurchase(from: result)
        }catch{
            print(error)
        }
        
    }
}

private extension DeckStore {
    
    @MainActor
    func retrieveProducts() async {
        do {
            let products = try await Product.products(for: [EXTENDED_DECK_1])
            items = products
        } catch {
            print(error)
        }
    }
    
    func handlePurchase(from result: PurchaseResult) async throws {
        switch result {
        case .success(let verifcation):
            print("success")
            let transaction = try checkVerified(verifcation)
            
            //TODO: Update Ui
            await transaction.finish()
            
        case .pending:
            print("pending")
        case .userCancelled:
            print("Canceled")
        default:
            break
            
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            print("verification failed")
            throw StoreErrors.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}
