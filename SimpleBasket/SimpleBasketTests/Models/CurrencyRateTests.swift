//
//  CurrencyRateTests.swift
//  SimpleBasketTests
//
//  Created by Duyen Hoa Ha on 20.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import XCTest

@testable import SimpleBasket
class CurrencyRateTests: XCTestCase {
    var currencyRate: CurrencyRate?
    let sourceCurrency = Currency.USD
    let destinationCurrency = Currency.CHF
    let fakeQuotePrice = Decimal(2.333)

    override func setUp() {
        super.setUp()

        currencyRate = CurrencyRate(with: sourceCurrency, destinationCurrency: destinationCurrency, quote: fakeQuotePrice)
    }

    override func tearDown() {
        currencyRate = nil
        super.tearDown()
    }

    func testInitialisation() {
        XCTAssertNotNil(currencyRate)
        XCTAssertEqual(currencyRate?.sourceCurrency, sourceCurrency)
        XCTAssertEqual(currencyRate?.destinationCurrency, destinationCurrency)
        XCTAssertEqual(currencyRate?.quote, fakeQuotePrice)
    }
}
