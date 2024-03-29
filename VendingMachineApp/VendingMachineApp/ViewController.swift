//
//  ViewController.swift
//  VendingMachineApp
//
//  Created by moon on 2018. 6. 22..
//  Copyright © 2018년 moon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StockCheckable {
    
    private struct BeverageImageSize {
        static let width: CGFloat = 140
        static let height: CGFloat = 100
    }
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet var stockLabels: [UILabel]!
    @IBOutlet var stockImageViews: [UIImageView]!
    @IBOutlet var purchaseButtons: [UIButton]!
    @IBOutlet var priceLabels: [UILabel]!
    @IBOutlet weak var purchasedContainer: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        purchasedContainer.contentSize.width = BeverageImageSize.width
        stockImageViews.forEach { setupBeverageImageView($0) }
        setupHistroyImageViews()
        setupPriceLabels()
        setupBalanceLabel()
        setupNotification()
        updateStockLabels()
    }

    // MARK: Setup methods
    private func setupBeverageImageView(_ imageView: UIImageView) {
        imageView.setBeverageImage()
        imageView.frame.size = CGSize(width: 140, height: 100)
    }
    
    private func setupHistroyImageViews() {
        let beverages: [Beverage] = VendingMachine.shared().readHistory()
        for (index, beverage) in beverages.enumerated() {
            updatePurchasedImageView(beverage, index)
        }
    }
    
    private func setupPriceLabels() {
        for index in priceLabels.indices {
            if let menu = Menu.init(rawValue: index) {
                priceLabels[index].text = "\(menu.price)원"
                priceLabels[index].adjustsFontSizeToFitWidth = true
            }
        }
    }
    
    private func setupBalanceLabel() {
        self.balanceLabel.text = String(format: "%d원", VendingMachine.shared().readBalance())
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeBalance(notification:)), name: .didChangeBalance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeStock(notification:)), name: .didChangeStock, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didAddHistory(notification:)), name: .didChangeHistory, object: VendingMachine.shared())
    }
    
    // MARK: Observer's selectors
    @objc private func didChangeBalance(notification: Notification) {
        guard let balance = notification.userInfo?["balance"] as? Int else {
            return
        }
        self.balanceLabel.text = String(format: "%d원", balance)
    }
    
    @objc private func didChangeStock(notification: Notification) {
        self.updateStockLabels()
    }
    
    @objc private func didAddHistory(notification: Notification) {
        guard let purchased = notification.userInfo?["purchased"] as? Beverage else {
            return
        }
        updatePurchasedImageView(purchased, VendingMachine.shared().readHistory().count - 1)
    }
    
    // MARK: Update methods
    private func updatePurchasedImageView(_ beverage: Beverage, _ multiplier: Int) {
        let purchased: UIImageView = ImageViewFactory.makeImageView(beverage)
        setupBeverageImageView(purchased)
        purchased.contentMode = .scaleToFill
        self.purchasedContainer.addSubview(purchased)
        purchased.frame.origin.x = purchasedContainer.frame.origin.x + CGFloat(multiplier * 50)
        self.purchasedContainer.contentSize.width += 50
    }
    
    // MARK: Action methods
    @IBAction func insertMoney(_ sender: UIButton) {
        let money: Int = Int(sender.titleLabel?.text ?? "") ?? 0
        VendingMachine.shared().insertMoney(money)
    }
    
    @IBAction func purchaseStock(_ sender: UIButton) {
        guard let buttonIndex = self.purchaseButtons.index(of: sender) else { return }
        guard let menu = Menu.init(rawValue: buttonIndex) else { return }
        VendingMachine.shared().purchaseBeverage(menu)
    }
}
