//
//  Coffee.swift
//  VendingMachineApp
//
//  Created by moon on 2018. 6. 23..
//  Copyright © 2018년 moon. All rights reserved.
//

import Foundation

class Coffee: Beverage {
    private var country: String
    
    init(name: String, price: Int, country: String) {
        self.country = country
        super.init(name: name, price: price)
    }
    
    convenience init() {
        self.init(name: DefaultData.coffee.name, price: DefaultData.coffee.price, country: "콜롬비아")
    }
    
    private struct NSCoderKeys {
        static let countryKey = "country"
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(country as NSString, forKey: NSCoderKeys.countryKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let country = aDecoder.decodeObject(of: NSString.self, forKey: NSCoderKeys.countryKey) else {
            return nil
        }
        self.country = country as String
        super.init(coder: aDecoder)
    }
}
