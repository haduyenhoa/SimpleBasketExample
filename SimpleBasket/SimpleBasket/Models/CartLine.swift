//
//  CartLine.swift
//  SimpleBasket
//
//  Created by Duyen Hoa Ha on 20.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import Foundation

class CartLine {
    var product: ProductInfo
    var quantity: UInt

    init(with product: ProductInfo, quantity: UInt) {
        self.product = product
        self.quantity = quantity
    }

    func quotedPrice(by currencyRate: CurrencyRate) -> Decimal {
        return NSDecimalNumber(decimal: currencyRate.quote)
            .multiplying(by: NSDecimalNumber(decimal: product.price))
            .multiplying(by: NSDecimalNumber(value: quantity))
            .decimalValue
    }
}
