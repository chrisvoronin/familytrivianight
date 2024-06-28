//
//  StoreViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 5/30/21.
//  Copyright © 2021 Chris Voronin. All rights reserved.
//

import UIKit

protocol StoreViewControllerDelegate: AnyObject {
    func onPurchaseControllerFinished(board: Board)
}

class StoreViewController: UIViewController {

    var board: Board!
    weak var delegate:StoreViewControllerDelegate?
    private var beganCheck = false
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var stackButtons: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = "To play premium games you need a subscription $1.49 per 3 month. Would you like to play premium games?"
    }
    
    private func showProgress(_ show:Bool) {
        if show {
            stackButtons.isHidden = true
            activityIndicator.startAnimating()
        } else {
            stackButtons.isHidden = false
            activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func onPrivacyPolicy(_ sender: Any) {
        let sb = UIStoryboard(name: "store", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "legal")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onTermsOfService(_ sender: Any) {
        let sb = UIStoryboard(name: "store", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "terms")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onProceed(_ sender: Any) {
        if IAPHandler.shared.canMakePurchases() {
            startPurchase()
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                alert.dismiss(animated: true) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onRestore(_ sender: Any) {
        startRestore()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startRestore() {
        showProgress(true)
        self.lblTitle.text = "Restoring Purchases..."
        
        IAPHandler.shared.restorePurchasesBlock = { [weak self] (type) in
            switch type {
            case .disabled, .notpurchased, .failed:
                DispatchQueue.main.async {
                    self?.showAlert(type.message())
                    self?.showProgress(false)
                }
            case .restored, .purchased:
                DispatchQueue.main.async {
                    self?.showAlertWithCallback(type.message())
                }
            }
        }
        IAPHandler.shared.restorePurchase()
    }
    
    func startPurchase() {
        
        showProgress(true)
        IAPHandler.shared.fetchProductsBlock = { (result) in
            if result.count > 0 {
                let product = result[0]
                // connect callback
                IAPHandler.shared.purchaseStatusBlock = { [weak self] (purchaseResult) in
                    switch purchaseResult {
                    case .purchased, .restored:
                        DispatchQueue.main.async {
                            self?.showAlertWithCallback(purchaseResult.message())
                        }
                    default:
                        DispatchQueue.main.async {
                            self?.showAlert(purchaseResult.message())
                            self?.showProgress(false)
                        }
                    }
                }
                // do purchase
                IAPHandler.shared.purchaseProduct(product)
            }
        }
        lblTitle.text = "Fetching Subscription..."
        IAPHandler.shared.fetchAvailableProducts()
    }
    
    private func showAlert(_ message:String) {
        let vc = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(vc, animated: true, completion: nil)
    }
    
    private func showAlertWithCallback(_ message:String) {
        let vc = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
            self?.callDelegate()
        }))
        self.present(vc, animated: true, completion: nil)
    }
    
    func callDelegate() {
        let copy = self.board!
        self.dismiss(animated: true) {
            self.delegate?.onPurchaseControllerFinished(board: copy)
        }
    }
}
