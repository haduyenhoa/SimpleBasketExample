//
//  CheckoutViewController.swift
//  SimpleBasket
//
//  Created by Duyen Hoa Ha on 19.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
    @IBOutlet weak var lblUsdPrice: UILabel!
    @IBOutlet weak var lblQuotedPrice: UILabel!

    @IBOutlet weak var lblQuoting: UILabel!
    @IBOutlet weak var ivQuoting: UIActivityIndicatorView!

    var waitingView: UIView?

    private var quotedCurrency: Currency?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let totalPrice = Cart.shareCart.totalPrice(rate: nil)
        lblUsdPrice.text = "Total price in USD: \(Catalog.sharedCatalog.numberFormatter.string(from: totalPrice) ?? "")"
        
        if let currency = quotedCurrency {
            lblQuotedPrice.alpha = 1.0
            lblQuotedPrice.textColor = UIColor.gray
            lblQuotedPrice.text = "Total price in \(currency.rawValue): ..."

            updateQuotingStatus(with: true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true

            quote(with: currency)
        } else {
            lblQuotedPrice.alpha = 0.0

            updateQuotingStatus(with: false)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        super.viewWillDisappear(animated)
    }

    func updateQuotingStatus(with showQuoting: Bool) {
        if showQuoting {
            lblQuotedPrice.textColor = UIColor.gray
            lblQuoting.alpha = 1.0
            ivQuoting.alpha = 1.0
        } else {
            lblQuotedPrice.textColor = UIColor.black
            lblQuoting.alpha = 0.0
            ivQuoting.alpha = 0.0
        }
    }

    func quote(with currency: Currency) {
        PriceProvider.shareProvider.retrieveCurrencyRate(from: Catalog.sharedCatalog.currency, destinationCurrency: currency) { (currencyRate, error) in
            if let rate = currencyRate {
                let quotedPrice = Cart.shareCart.totalPrice(rate: rate)
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.updateQuotingStatus(with: false)
                    self.lblQuotedPrice.text = "Total price in \(currency.rawValue): \(Catalog.sharedCatalog.numberFormatter.string(from: quotedPrice) ?? "")"
                }
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Cannot quote price. Please try again later", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.updateQuotingStatus(with: false)
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configure(with currency: Currency) {
        quotedCurrency = currency
    }
}

