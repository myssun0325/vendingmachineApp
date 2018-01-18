//
//  Protocols.swift
//  VendingMachine
//
//  Created by 심 승민 on 2017. 12. 19..
//  Copyright © 2017년 JK. All rights reserved.
//

import Foundation

typealias Stock = Int
typealias Balance = Int
typealias Purchased = Int

protocol Product {
    associatedtype MenuType: EnumCollection, Purchasable
    var menuType: MenuType { get }
    func isExpired(with date: Date) -> Bool
    func isLowCalorie() -> Bool
    var productName: String { get }
    var price: Int { get }
}

protocol Machine: Sequence, Codable {
    associatedtype MenuType: EnumCollection, Purchasable
    associatedtype ProductType: Product
}

protocol Managable: Machine {
    func fullSupply(_ count: Int)

    func supply(_ menu: MenuType, _ count: Stock)

    func remove(_ menu: MenuType, _ count: Stock)

    func showPurchasedList() -> [HistoryInfo]

    func checkTheStock() -> [MenuType:Stock]
}

protocol UserServable: Machine {
    func popProduct(_ menu: MenuType) -> ProductType?

    func insertMoney(_ money: MoneyManager<Self>.Unit)

    func showBalance() -> Balance

    func showAffordableProducts() -> [MenuType]

    func showExpiredProducts(on day: Date) -> [MenuType:Stock]

    func showHotProducts() -> [MenuType]

    func checkTheStock() -> [MenuType:Stock]
}

protocol Purchasable {
    var price: Int { get }

    var productName: String { get }
}