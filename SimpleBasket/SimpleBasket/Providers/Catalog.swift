//
//  Catalog.swift
//  SimpleBasket
//
//  Created by Duyen Hoa Ha on 20.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import Foundation

class Catalog {
    var allProducts = [ProductInfo]()
    let currency: Currency

    static let sharedCatalog = Catalog(from: "catalog")
    let numberFormatter: NumberFormatter

    required init(from jsonFile: String) {
        numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.roundingMode = .halfUp

        //load product
        let mainBundle = Bundle.main
        guard let jsonPath = mainBundle.path(forResource: jsonFile, ofType: "json") else {
            currency = .USD
            return
        }

        let jsonUrl = URL(fileURLWithPath: jsonPath)
        guard let jsonData = try? Data.init(contentsOf: jsonUrl, options: Data.ReadingOptions.mappedIfSafe) else {
            currency = .USD
            return
        }

        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
            currency = .USD
            return
        }

        guard let productsJson = jsonObject?["products"] as? [[String: Any]], productsJson.count > 0 else {
            currency = .USD
            return
        }

        for productDict in productsJson {
            if let description = productDict["description"] as? String, let price = productDict["price"] as? NSNumber {
                allProducts.append(ProductInfo(with: description, price: price.decimalValue))
            }
        }

        if let jsonCurrency = jsonObject?["currency"] as? String, let _currency = Currency(rawValue: jsonCurrency) {
            currency = _currency
        } else {
            currency = .USD //false back, it should not happen
        }
    }
}
