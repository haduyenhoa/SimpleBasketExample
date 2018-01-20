//
//  PriceProviderTests.swift
//  SimpleBasketTests
//
//  Created by Duyen Hoa Ha on 20.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import XCTest

@testable import SimpleBasket
class PriceProviderTests: XCTestCase {
    var fakeUrlSession: FakeURLSession?
    var priceProvider: PriceProvider?

    override func setUp() {
        super.setUp()

        fakeUrlSession = FakeURLSession()
        priceProvider = PriceProvider(with: fakeUrlSession!)
    }
    
    override func tearDown() {
        priceProvider = nil
        fakeUrlSession = nil

        super.tearDown()
    }
    
    func testInitialisation() {
        XCTAssertNotNil(priceProvider)
    }

    func testRetrieveCurrencyRatesSucceed() {
        fakeUrlSession?.responseStatus = .succeed
        guard let jsonObject = getSuccessJsonObject() else {
            XCTAssertFalse(true, "Cannot get success json object")
            return
        }

        fakeUrlSession?.successfulResponse = jsonObject as Any

        var foundRate: CurrencyRate?
        var foundError: Error?
        let expectation = XCTestExpectation(description: "wait for retrieving currency rate")

        priceProvider?.retrieveCurrencyRate(from: .USD, destinationCurrency: .EUR, completion: { (currencyRate, error) in
            foundRate = currencyRate
            foundError = error
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 2)

        XCTAssertNil(foundError)
        XCTAssertNotNil(foundRate)

        XCTAssertEqual(foundRate?.sourceCurrency, .USD)
        XCTAssertEqual(foundRate?.destinationCurrency, .EUR)
        XCTAssertEqual(foundRate?.quote, Decimal(57.8936))
    }

    func testRetrieveCurrencyRatesFail() {
        fakeUrlSession?.responseStatus = .fail

        var foundRate: CurrencyRate?
        var foundError: Error?
        let expectation = XCTestExpectation(description: "wait for retrieving currency rate")

        priceProvider?.retrieveCurrencyRate(from: .USD, destinationCurrency: .EUR, completion: { (currencyRate, error) in
            foundRate = currencyRate
            foundError = error
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 2)

        XCTAssertNil(foundRate)
        XCTAssertNotNil(foundError)
    }

    func testRetrieveCurrencyRatesInvalidData() {
        fakeUrlSession?.responseStatus = .invalidData

        var foundRate: CurrencyRate?
        var foundError: Error?
        let expectation = XCTestExpectation(description: "wait for retrieving currency rate")

        priceProvider?.retrieveCurrencyRate(from: .USD, destinationCurrency: .EUR, completion: { (currencyRate, error) in
            foundRate = currencyRate
            foundError = error
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 2)

        XCTAssertNil(foundRate)
        XCTAssertNotNil(foundError)
    }

    func testRetrieveCurrencyRatesInvalidResponse() {
        fakeUrlSession?.responseStatus = .invalidStatusCode

        var foundRate: CurrencyRate?
        var foundError: Error?
        let expectation = XCTestExpectation(description: "wait for retrieving currency rate")

        priceProvider?.retrieveCurrencyRate(from: .USD, destinationCurrency: .EUR, completion: { (currencyRate, error) in
            foundRate = currencyRate
            foundError = error
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 2)

        XCTAssertNil(foundRate)
        XCTAssertNotNil(foundError)
    }

    func testRetrieveCurrencyRatesUnthorized() {
        fakeUrlSession?.responseStatus = .unauthorized

        var foundRate: CurrencyRate?
        var foundError: Error?
        let expectation = XCTestExpectation(description: "wait for retrieving currency rate")

        priceProvider?.retrieveCurrencyRate(from: .USD, destinationCurrency: .EUR, completion: { (currencyRate, error) in
            foundRate = currencyRate
            foundError = error
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 2)

        XCTAssertNil(foundRate)
        XCTAssertNotNil(foundError)
    }

    //MARK: Helpers
    private func getSuccessJsonObject() -> [String: Any]? {
        let testBundle = Bundle(for: PriceProviderTests.self)

        guard let jsonPath = testBundle.path(forResource: "rate", ofType: "json") else {
            XCTAssertFalse(true, "Verify if rate.json is included in test target")
            return nil
        }

        let jsonUrl = URL(fileURLWithPath: jsonPath)
        guard let jsonData = try? Data.init(contentsOf: jsonUrl, options: Data.ReadingOptions.mappedIfSafe) else {
            XCTAssertFalse(true, "Check if rate.json contains valid response for currency rates")
            return nil
        }

        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
            XCTAssertFalse(true, "Check if rate.json contains valid response for currency rates")
            return nil
        }

        return jsonObject
    }
}
