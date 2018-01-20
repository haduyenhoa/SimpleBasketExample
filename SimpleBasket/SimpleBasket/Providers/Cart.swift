//
//  File.swift
//  SimpleBasket
//
//  Created by Duyen Hoa Ha on 20.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import Foundation

class Cart {
    var cartLines: [CartLine] = [CartLine]()

    static let shareCart = Cart()

    /**
     Remove a product from cart
     - Parameter product: product to be removed
    */
    func remove(_ product: ProductInfo) {
        cartLines = cartLines.filter({ (cartLine) -> Bool in
            return cartLine.product != product
        })
    }

    /**
     Add or update a product in to cart
     - Parameter product: product to be added or updated
     - Parameter newQuantity: new quantity of this product
    */
    func addOrUpdate(_ product: ProductInfo, newQuantity: UInt) {
        if newQuantity == 0 {
            cartLines = cartLines.filter({ $0.product != product })
            return
        }

        var needToAdd = true
        cartLines = cartLines.map({ (cartLine) -> CartLine in
            if cartLine.product == product {
                cartLine.quantity = newQuantity
                needToAdd = false
            }

            return cartLine
        })

        if needToAdd {
            cartLines.append(CartLine(with: product, quantity: newQuantity))
        }
    }

    /**
     Get total price of all products in cart
     - Parameter rate: currency rate to calculate the total price
     - returns: total price of all products in **NSDecimalNumber**
    */
    func totalPrice(rate: CurrencyRate?) -> NSDecimalNumber {
        var totalPrice = NSDecimalNumber(value: 0)

        for cartLine in cartLines {
            let qty = NSDecimalNumber(value: cartLine.quantity)
            let unitPrice = NSDecimalNumber(decimal: cartLine.product.price)
            var subPrice = unitPrice.multiplying(by: qty)

            if let quotedRate = rate {
                subPrice = subPrice.multiplying(by: NSDecimalNumber(decimal: quotedRate.quote))
            }

            totalPrice = totalPrice.adding(subPrice)
        }

        return totalPrice
    }
}
