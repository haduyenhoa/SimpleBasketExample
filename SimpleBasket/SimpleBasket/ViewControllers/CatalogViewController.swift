//
//  CatalogViewController.swift
//  SimpleBasket
//
//  Created by Duyen Hoa Ha on 19.01.18.
//  Copyright © 2018 HDH. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCheckout: UIButton!

    private var currentSelector: UIAlertController?

    private var editingProduct: ProductInfo?
    private var editingQuantity: UInt?

    private var quantityPickerData = [UInt]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 80.0
        tableView.tableFooterView = UIView()

        for quantity: UInt in 0...100 {
            quantityPickerData.append(quantity)
        }
    }

    func refreshCheckoutButton() {
        if Cart.shareCart.cartLines.count == 0 {
            btnCheckout.backgroundColor = UIColor.gray
            btnCheckout.isEnabled = false
        } else {
            btnCheckout.isEnabled = true
            btnCheckout.backgroundColor = UIColor(red: 0, green: 145.0/255.0, blue: 147.0/255.0, alpha: 1.0)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.title = "Catalog"

        refreshCheckoutButton()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkout(_ sender: Any) {
        currentSelector = self.currencySelector

        self.present(currentSelector!, animated: true)
    }

    func gotoCheckout(currency: Currency) {
        if let checkoutViewController = storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as? CheckoutViewController {
            let selectedRow = max(self.currencyPicker.selectedRow(inComponent: 0), 0)
            let currency = Currency.allValues[selectedRow]

            if currency != Catalog.sharedCatalog.currency {
                checkoutViewController.configure(with: Currency.allValues[selectedRow])
            }

            self.navigationController?.pushViewController(checkoutViewController, animated: true)
        }
    }

    func showQuantitySelection(with product: ProductInfo, currentQuantity: UInt) -> Void {
        editingProduct = product
        editingQuantity = currentQuantity

        currentSelector = self.quantitySelector
        quantityPicker.selectRow(quantityPickerData.index(of: currentQuantity)!, inComponent: 0, animated: false)

        self.present(currentSelector!, animated: true)
    }

    //MARK: Lazy vars
    lazy var currencyPicker: UIPickerView = {
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 280, height: 300))
        picker.delegate = self
        picker.dataSource = self

        return picker
    }()

    lazy var quantityPicker: UIPickerView = {
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 280, height: 300))
        picker.delegate = self
        picker.dataSource = self

        return picker
    }()

    lazy var currencySelector: UIAlertController = {
        [unowned self] in

        let contentVC = UIViewController()
        contentVC.preferredContentSize = CGSize(width: 280,height: 300)
        contentVC.view.addSubview(self.currencyPicker)

        let alert = UIAlertController(title: "Choose currency", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.setValue(contentVC, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Checkout", style: .default, handler: { (action) in
            let currency = Currency.allValues[self.currencyPicker.selectedRow(inComponent: 0)]

            self.gotoCheckout(currency: currency)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        return alert
        }()

    lazy var quantitySelector: UIAlertController = {
        [unowned self] in

        var selectedRow = 0
        if let currentQuantity = self.editingQuantity {
            selectedRow = self.quantityPickerData.index(of: currentQuantity) ?? 0
        }

        let contentVC = UIViewController()
        contentVC.preferredContentSize = CGSize(width: 280,height: 300)
        contentVC.view.addSubview(self.quantityPicker)

        let alert = UIAlertController(title: "Choose new quantity", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.setValue(contentVC, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let newQuantity = self.quantityPickerData[self.quantityPicker.selectedRow(inComponent: 0)]
            guard let product = self.editingProduct else {
                return
            }

            if newQuantity == 0 {
                Cart.shareCart.remove(product)
            } else {
                Cart.shareCart.addOrUpdate(product, newQuantity: newQuantity)
            }

            self.refreshCheckoutButton()

            self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows ?? [], with: UITableViewRowAnimation.none)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        return alert
        }()
}

extension CatalogViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Catalog.sharedCatalog.allProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartLineCellIdentifier") as! CartLineCell

        let product = Catalog.sharedCatalog.allProducts[indexPath.row]
        let cartLine = Cart.shareCart.cartLines.first(where: { $0.product == product})

        cell.configure(with: product,
                       quantity: cartLine?.quantity ?? 0,
                       currency: Catalog.sharedCatalog.currency) { (product, quantity) -> (Void) in
            self.showQuantitySelection(with: product, currentQuantity: quantity)
        }

        return cell
    }
}

extension CatalogViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.currentSelector == self.quantitySelector {
            return "\(quantityPickerData[row])"
        } else {
            return "\(Currency.allValues[row].rawValue)"
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
}

extension CatalogViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.currentSelector == self.quantitySelector {
            return quantityPickerData.count
        } else {
            return Currency.allValues.count
        }
    }
}
