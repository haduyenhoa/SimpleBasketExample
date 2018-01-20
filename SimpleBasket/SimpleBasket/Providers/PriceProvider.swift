//
//  PriceProvider.swift
//  SimpleBasket
//
//  Created by Duyen Hoa Ha on 19.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import Foundation

class PriceProvider {
    private let apiKey = "ebd99c3afe968c09e35e0f802d0095d1"
    private var dataTask: URLSessionDataTask?
    private let downloadSession: URLSession

    static let shareProvider = PriceProvider(with: URLSession(configuration: .default))

    init(with urlSession: URLSession) {
        downloadSession = urlSession
    }

    /// Retrieve currency rate from currencylayer.com
    ///
    /// **Usage**:
    /// ```
    /// let priceProvider = PriceProvider(with: URLSession(configuration: .default))
    /// priceProvider.retrieveCurrencyRate(from: currencyA, destinationCurrency: currencyB) { (currencyRate, error) in
    ///     //completion handler code...
    /// }
    /// ```
    ///
    /// - Parameter from: from currency
    /// - Parameter destinationCurrency: to currency
    /// - Parameter completionHandler: block of code which will be called once currency rate is retrieved
    func retrieveCurrencyRate(from sourceCurrency: Currency,
                              destinationCurrency: Currency,
                              completion: @escaping ((CurrencyRate?, Error?) -> Void)) {
        //generate url
        guard let rateConversionUrl = rateUrl(of: sourceCurrency, currencyB: destinationCurrency) else {
            completion(nil, NSError(domain: "ProviderConfiguration", code: 3001, userInfo: nil))
            return
        }

        dataTask?.cancel()
        dataTask = downloadSession.dataTask(with: rateConversionUrl as URL, completionHandler: { (data, response, error) in
            if let _error = error {
                completion(nil, _error)
                return
            }

            if let _data = data {
                let parseResult = self.parse(from: _data, sourceCurrency: sourceCurrency, quotedCurrency: destinationCurrency)
                completion(parseResult.0, parseResult.1)
                return
            }

            completion(nil, nil) //this should not happen
        })

        dataTask?.resume()
    }

    // MARK: Private functions
    /**
     Parse json data to retrieve **CurrencyRate** related to *sourceCurrency* and *quotedCurrency*
     - Parameter jsonData: data to be parsed
     - Parameter sourceCurrency: source currency
     - Parameter quotedCurrency: quoted currency
     - returns: tuple which contains eventuel CurrencyRate or Error
    */
    private func parse(from jsonData: Data, sourceCurrency: Currency, quotedCurrency: Currency) -> (CurrencyRate?, Error?) {
        var jsonObject: [String: Any]?
        do {
            jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
        } catch {
            return (nil, error)
        }

        //check validity of the json
        guard let validJsonObject = jsonObject,
            let source = validJsonObject["source"] as? String, let sourceCurrency = Currency(rawValue: source),
            let quotesDict = validJsonObject["quotes"] as? [String: Any],
            let quotedValue = (quotesDict["\(sourceCurrency.rawValue)\(quotedCurrency.rawValue)"] as? NSNumber)?.decimalValue
            else {
                return (nil, NSError(domain: "JsonValidity", code: 2001, userInfo: nil))
        }

        return (CurrencyRate(with: sourceCurrency,
                             destinationCurrency: quotedCurrency,
                             quote: quotedValue),
                nil)
    }

    /**
     Generate url of the currency service
     - Parameter currencyA: source currency
     - Parameter currencyB: destination currency
     - Returns: url (if available) of the currency service
    */
    private func rateUrl(of currencyA: Currency, currencyB: Currency) -> URL? {
        let currenciesQuery = "currencies=\(currenciesQueryParam())"
        return URL(string: "http://apilayer.net/api/live?access_key=\(apiKey)&\(currenciesQuery)&source=\(Currency.USD.rawValue.uppercased())&format=1")
    }

    /**
     Generate *&currencies=* querry parameter
    */
    private func currenciesQueryParam() -> String {
        return Currency.allValues.reduce("", { (result, currency) -> String in
            return result + ",\(currency.rawValue)"
        })
    }
}
