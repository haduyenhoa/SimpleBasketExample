//
//  CatalogTests.swift
//  SimpleBasketTests
//
//  Created by Duyen Hoa Ha on 20.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import XCTest

@testable import SimpleBasket
class CatalogTests: XCTestCase {
    
    var testCatalog: Catalog?

    override func setUp() {
        super.setUp()

        testCatalog = Catalog(from: "testCatalog")
    }

    override func tearDown() {
        testCatalog = nil

        super.tearDown()
    }

    func testInitialisation() {
        XCTAssertNotNil(testCatalog)

        XCTAssertEqual(testCatalog?.currency, .CHF)
        XCTAssertEqual(testCatalog?.allProducts.count, 4)
        XCTAssertEqual(testCatalog?.numberFormatter.minimumFractionDigits, 2)
        XCTAssertEqual(testCatalog?.numberFormatter.maximumFractionDigits, 2)
        XCTAssertEqual(testCatalog?.numberFormatter.minimumIntegerDigits, 1)
        XCTAssertEqual(testCatalog?.numberFormatter.roundingMode, NumberFormatter.RoundingMode.halfUp)

        XCTAssertEqual(testCatalog?.allProducts.first?.description, "Fake product 1")
        XCTAssertEqual(testCatalog?.allProducts.first?.price, Decimal(100.2222))
    }
}
