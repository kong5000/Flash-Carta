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
    
    @Published var hasError = false
    
    private var transactionListener: TransactionListener?
    
    func configureTransactionListener() -> TransactionListener {
        Task.detached(priority: .background) { @MainActor [weak self] in
            do{
                for await result in Transaction.updates{
                    let transaction = try self?.checkVerified(result)
                    
                    self?.action = .successful
                    await transaction?.finish()
                }
            }catch{
                self?.action = .failed(.system(error))
                print(error)
            }
        }
    }
    
    init(){
        Task{ [ weak self] in
            await self?.retrieveProducts()
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
    
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                //TODO: Update UI for customer?

                    //Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }
}
