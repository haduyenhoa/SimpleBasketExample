//
//  ProductInfo.swift
//  SimpleBasket
//
//  Created by Duyen Hoa Ha on 19.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import Foundation

struct ProductInfo {
    let price: Decimal
    let description: String

    init(with description: String, price: Decimal) {
        self.description = description
        self.price = price
    }
}

extension ProductInfo: Equatable {
    static func ==(lhs: ProductInfo, rhs: ProductInfo) -> Bool {
        return lhs.price == rhs.price
            && lhs.description == rhs.description
    }

    static func !=(lhs: ProductInfo, rhs: ProductInfo) -> Bool {
        return lhs.price != rhs.price
            || lhs.description != rhs.description
    }
}
