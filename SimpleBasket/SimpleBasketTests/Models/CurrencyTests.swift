//
//  CurrencyTests.swift
//  SimpleBasketTests
//
//  Created by Duyen Hoa Ha on 20.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import XCTest

@testable import SimpleBasket
class CurrencyTests: XCTestCase {

    func testCurrencyCount() {
        XCTAssertEqual(Currency.allValues.count, 3)
        XCTAssertTrue(Currency.allValues.contains(.USD))
        XCTAssertTrue(Currency.allValues.contains(.CHF))
        XCTAssertTrue(Currency.allValues.contains(.EUR))
    }

    func testCurrencyRawValue() {
        XCTAssertEqual(Currency.USD.rawValue, "USD")
        XCTAssertEqual(Currency.CHF.rawValue, "CHF")
        XCTAssertEqual(Currency.EUR.rawValue, "EUR")
    }
}
