//
//  CurrencyRate.swift
//  SimpleBasket
//
//  Created by Duyen Hoa Ha on 19.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import Foundation

class CurrencyRate {
    let sourceCurrency: Currency
    let destinationCurrency: Currency
    let quote: Decimal

    init(with sourceCurrency: Currency,
         destinationCurrency: Currency,
         quote: Decimal) {
        self.sourceCurrency = sourceCurrency
        self.destinationCurrency = destinationCurrency
        self.quote = quote
    }
}
