//
//  Store.swift
//  FlashCarta
//
//  Created by Keith Ong on 2024-04-18.
//

import Foundation
import StoreKit
typealias Transaction = StoreKit.Transaction
typealias PurchaseResult = Product.PurchaseResult
typealias TransactionListener = Task<Void, Error>


enum StoreError: LocalizedError {
    case failedVerification
    case system(Error)
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "User transaction failed"
        case .system(let err):
            return err.localizedDescription
        }
    }
}

enum StoreAction {
    case successful
    case failed(StoreError)
}

let EXTENDED_DECK_1 = "keith.FlashCarta.extendedDecks"

class DeckStore: ObservableObject {
    
    @Published private(set) var action: StoreAction?
    
    @Published private(set) var items = [Product]()
    @Published private(set) var purchasedItems = [Product]()

    @Published var hasError = false
    
    init(){
        Task{ [ weak self] in
            
            await self?.retrieveProducts()
        
            await self?.updateCustomerProductStatus()
        }
    }
    
    func purchase (_ item: Product) async {
        do{
            let result = try await item.purchase()
            print(result)
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
            print(items)
        } catch {
            print(error)
        }
    }
    
    func handlePurchase(from result: PurchaseResult) async throws {
        switch result {
        case .success(let verifcation):
            print("success")
            let transaction = try checkVerified(verifcation)
            //The transaction is verified. Deliver content to the user.
            await updateCustomerProductStatus()
            //TODO: Update Ui
            action = .successful
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
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    
    @MainActor
    func updateCustomerProductStatus() async {
        print("UPDATE STATUS")

        //Iterate through all of the user's purchased products.
        for await result in Transaction.currentEntitlements {
            do {
                //Check whether the transaction is verified. If it isn’t, catch `failedVerification` error.
                let transaction = try checkVerified(result)

                //Check the `productType` of the transaction and get the corresponding product from the store.
                switch transaction.productType {
                case .nonConsumable:
                    if let item = items.first(where: { $0.id == transaction.productID }) {
                        purchasedItems.append(item)
                    }
                    print(purchasedItems)
                    
                default:
                    break
                }
            } catch {
                print()
            }
        }

        // Update product state
    }
    
    func isPurchased(_ productIdentifier: String) async throws -> Bool {
        guard let result = await Transaction.latest(for: productIdentifier) else{
            return false
        }
        let transaction =  try checkVerified(result)
        
        //Check if the user has refunded
        return transaction.revocationDate == nil
    }
    
    //Transaction listeners dont listen to purchase()
}
