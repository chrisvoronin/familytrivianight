//
//  IAPHandler.swift
//  Family Trivia
//
//  Created by Chris Voronin on 11/20/20.
//  Copyright © 2020 Chris Voronin. All rights reserved.
//

import UIKit
import StoreKit

enum IAPHandlerResultType {
    
    case disabled
    case restored
    case purchased
    case notpurchased
    case failed
    
    func message() -> String {
        switch self {
        case .failed: return "Unable to complete the purchase."
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully completed this purchase!"
        case .notpurchased: return "We were unable to find an active subscription."
        }
    }
}


class IAPHandler: NSObject {
    
    static let shared = IAPHandler()
    
    let SUBSCRIPTION_PRODUCT_ID = "subscription"
    
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    private(set) var haveProductsBeenFetched:Bool = false
    private(set) var hasPurchasedSubscription:Bool = false
    
    var fetchProductsBlock: (([SKProduct]) -> Void)?
    var restorePurchasesBlock: ((IAPHandlerResultType) -> Void)?
    var purchaseStatusBlock: ((IAPHandlerResultType) -> Void)?
    
    override init() {
        super.init()
        restoreUserPuchaseFlag()
    }
    
    func connectObserver() {
        SKPaymentQueue.default().add(self)
    }
    
    func disconnectObserver() {
        SKPaymentQueue.default().remove(self)
    }
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(){
        
        if haveProductsBeenFetched {
            fetchProductsBlock?(iapProducts)
            return
        }
        
        // Put here your IAP Products ID's
        let productIdentifiers:Set<String> = [SUBSCRIPTION_PRODUCT_ID]
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    // MARK: - CHECK IF PRODUCT CAN BE BOUGHT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    // MARK: - PURCHASE PRODUCT
    func purchaseProduct(_ product:SKProduct){
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func saveUserPurchaseFlag() {
        UserDefaults.standard.setValue(hasPurchasedSubscription, forKey: "hasPurchased")
    }
    private func restoreUserPuchaseFlag() {
        hasPurchasedSubscription = UserDefaults.standard.bool(forKey: "hasPurchased")
    }
    
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // MARK: - RESPONSE TO FETCH PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        iapProducts = response.products
        haveProductsBeenFetched = true
        fetchProductsBlock?(response.products)
    }
    
    // MARK: - RESPONSE TO RESTORING PURCHASES
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        var result:IAPHandlerResultType = .notpurchased
        
        for trans in queue.transactions {
            switch trans.transactionState {
            case .purchased, .restored:
                if trans.payment.productIdentifier == SUBSCRIPTION_PRODUCT_ID {
                    hasPurchasedSubscription = true
                    result = .restored
                    saveUserPurchaseFlag()
                }
            default:
                print("\(trans.payment.productIdentifier) = NOT ACTIVE")
            }
        }
        restorePurchasesBlock?(result)
    }
    
    // MARK: PURCHASE TRANSACTION RESPONSE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
                
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    hasPurchasedSubscription = true
                    saveUserPurchaseFlag()
                    purchaseStatusBlock?(.purchased)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .failed:
                    print("failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.notpurchased)
                    break
                case .restored:
                    print("restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.restored)
                    break
                default:
                    break
                }
            }
        }
    }
}
