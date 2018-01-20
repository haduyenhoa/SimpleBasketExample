//
//  ProductInfoTests.swift
//  SimpleBasketTests
//
//  Created by Duyen Hoa Ha on 20.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import XCTest

@testable import SimpleBasket
class ProductInfoTests: XCTestCase {
    var product: ProductInfo?
    let fakeDescription = "fake description"
    let fakePrice = Decimal(1.3333)

    override func setUp() {
        super.setUp()

        product = ProductInfo(with: fakeDescription, price: fakePrice)
    }
    
    override func tearDown() {
        product = nil

        super.tearDown()
    }

    func testInitialisation() {
        XCTAssertNotNil(product)
        XCTAssertEqual(product?.description, fakeDescription)
        XCTAssertEqual(product?.price, fakePrice)
    }
}
