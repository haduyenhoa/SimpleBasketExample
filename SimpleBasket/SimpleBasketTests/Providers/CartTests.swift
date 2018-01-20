//
//  CartTests.swift
//  SimpleBasketTests
//
//  Created by Duyen Hoa Ha on 20.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import XCTest

@testable import SimpleBasket
class CartTests: XCTestCase {
    var cart: Cart?
    override func setUp() {
        super.setUp()

        cart = Cart()
    }
    
    override func tearDown() {
        cart = nil

        super.tearDown()
    }
    
    func testInitialisation() {
        XCTAssertNotNil(cart)
        XCTAssertEqual(cart?.cartLines.count, 0)
    }

    func testAddNewProduct() {
        let fakeProduct = ProductInfo(with: "fake description", price: Decimal(100.1234))
        let fakeQuantity: UInt = 100
        cart?.addOrUpdate(fakeProduct, newQuantity: fakeQuantity)

        XCTAssertEqual(cart?.cartLines.count, 1)
        XCTAssertEqual(cart?.cartLines[0].product, fakeProduct)
        XCTAssertEqual(cart?.cartLines[0].quantity, fakeQuantity)
    }

    func testUpdateProductQuantity() {
        let fakeProduct = ProductInfo(with: "fake description", price: Decimal(100.1234))
        let fakeQuantity: UInt = 100
        cart?.addOrUpdate(fakeProduct, newQuantity: fakeQuantity)

        XCTAssertEqual(cart?.cartLines.count, 1)
        XCTAssertEqual(cart?.cartLines[0].product, fakeProduct)
        XCTAssertEqual(cart?.cartLines[0].quantity, fakeQuantity)

        cart?.addOrUpdate(fakeProduct, newQuantity: 300)
        XCTAssertEqual(cart?.cartLines.count, 1)
        XCTAssertEqual(cart?.cartLines[0].quantity, 300, "product must be updated correctly with new quantity")

        cart?.addOrUpdate(fakeProduct, newQuantity: 0)
        XCTAssertEqual(cart?.cartLines.count, 0, "product must be remove from cart if new quantity is zero")
    }

    func testRemoveProductDoesNotExistInCart() {
        let fakeProduct = ProductInfo(with: "fake description", price: Decimal(100.1234))
        let fakeQuantity: UInt = 100
        cart?.addOrUpdate(fakeProduct, newQuantity: fakeQuantity)
        XCTAssertEqual(cart?.cartLines.count, 1)

        let nonExistProduct = ProductInfo(with: "non exist product", price: Decimal(1))
        cart?.remove(nonExistProduct)

        XCTAssertEqual(cart?.cartLines.count, 1, "removal of product not exist in cart does not effect cartlines")
    }

    func testRemoveProductInCart() {
        let fakeProduct = ProductInfo(with: "fake description", price: Decimal(100.1234))
        let fakeQuantity: UInt = 100
        cart?.addOrUpdate(fakeProduct, newQuantity: fakeQuantity)
        XCTAssertEqual(cart?.cartLines.count, 1)

        cart?.remove(fakeProduct)
        XCTAssertEqual(cart?.cartLines.count, 0, "product must be removed from cart")
    }

    func testQuotation() {
        let productA = ProductInfo(with: "product A", price: Decimal(2.32))
        let productB = ProductInfo(with: "product B", price: Decimal(2.15))

        cart?.addOrUpdate(productA, newQuantity: 50)
        cart?.addOrUpdate(productB, newQuantity: 100)

        let currencyRate = CurrencyRate(with: .USD, destinationCurrency: .EUR, quote: Decimal(3.0))

        let quotedPrice = cart?.totalPrice(rate: currencyRate)
        XCTAssertEqual(quotedPrice?.decimalValue, Decimal(993))
    }
}
