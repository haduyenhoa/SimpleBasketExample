//
//  CartLineTests.swift
//  SimpleBasketTests
//
//  Created by Duyen Hoa Ha on 20.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import XCTest

@testable import SimpleBasket
class CartLineTests: XCTestCase {
    var cartLine: CartLine?
    let fakeProduct = ProductInfo(with: "fake Description", price: Decimal(3))
    let fakeQuantity:UInt = 10

    override func setUp() {
        super.setUp()

        cartLine = CartLine(with: fakeProduct, quantity: fakeQuantity)
    }
    
    override func tearDown() {
        cartLine = nil

        super.tearDown()
    }
    
    func testInitialisation() {
        XCTAssertNotNil(cartLine)
        XCTAssertEqual(cartLine?.product, fakeProduct)
        XCTAssertEqual(cartLine?.quantity, fakeQuantity)
    }

    func testQuotation() {
        let currencyRate = CurrencyRate(with: .USD, destinationCurrency: .EUR, quote: Decimal(1.5))
        let quotedPrice = cartLine?.quotedPrice(by: currencyRate)

        let checkPrice = Decimal(45)
        XCTAssertEqual(quotedPrice, checkPrice)
    }
    
}
