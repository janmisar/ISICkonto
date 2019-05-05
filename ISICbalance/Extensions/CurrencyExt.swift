//
//  CurrencyExt.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 05/05/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation

extension Int {
    func asLocalCurrency() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = L10n.Balance.currency
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "es_Es")
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: self) ?? "0"
    }
}
