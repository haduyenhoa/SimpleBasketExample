//
//  CartLineCell.swift
//  SimpleBasket
//
//  Created by Duyen Hoa Ha on 20.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import UIKit

class CartLineCell: UITableViewCell {
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblUnitPrice: UILabel!
    @IBOutlet weak var btnQuantity: UIButton!

    private var product: ProductInfo?
    private var quantity: UInt = 0

    private var updateHandler: ((ProductInfo, UInt) -> (Void))?

    override func awakeFromNib() {
        super.awakeFromNib()
        btnQuantity.layer.cornerRadius = 5
    }

    /**
     Configure the tableViewCell with all necessary informations
     - Parameter product: Product of this cell
     - Parameter quantity: Quantity of this product
     - Parameter currency: Currency of this product
     - Parameter updateHandler: Block of code to be executed when user clicks on quantity button
    */
    func configure(with product: ProductInfo,
                   quantity: UInt,
                   currency: Currency,
                   updateHandler:@escaping (ProductInfo, UInt) -> (Void) ) {
        self.product = product
        self.quantity = quantity
        self.updateHandler = updateHandler

        //display Price
        let decimalNumber = NSDecimalNumber(decimal: product.price)
        let priceString = Catalog.sharedCatalog.numberFormatter.string(from: decimalNumber) ?? ""
        lblUnitPrice.text =  "\(currency.rawValue) \(priceString)"

        //display Description
        lblDescription.text = product.description

        //display Quantity
        if quantity > 0 {
            btnQuantity.backgroundColor = UIColor(red: 0, green: 145.0/255.0, blue: 147.0/255.0, alpha: 1.0)
            btnQuantity.setTitle("\(quantity)", for: .normal)
        } else {
            btnQuantity.backgroundColor = UIColor.gray
            btnQuantity.setTitle("+", for: .normal)
        }
    }

    @IBAction func updateQuantity(with sender: Any) {
        guard let product = self.product else {
            return
        }

        self.updateHandler?(product, quantity)
    }
}

