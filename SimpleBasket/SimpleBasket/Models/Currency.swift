//
//  Currency.swift
//  SimpleBasket
//
//  Created by Duyen Hoa Ha on 19.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import Foundation

enum Currency: String {
    case EUR = "EUR"
    case USD = "USD"
    case CHF = "CHF"

    static let allValues: [Currency] = [.EUR, .USD, .CHF]
}
