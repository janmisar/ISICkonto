//
//  BalanceViewModel.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 15/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation
import Result
import ReactiveSwift
import Alamofire
import UIKit

protocol BalanceViewModeling {
    var balance: Property<Int> { get }
    var localeBalance: Property<String> { get }
    var actions: BalanceViewModelingActions { get }
}

protocol BalanceViewModelingActions {
    var getBalance: Action<(),Balance,RequestError> { get }
}

extension BalanceViewModelingActions where Self: BalanceViewModeling {
    var actions: BalanceViewModelingActions { return self }
}

final class BalanceViewModel: BaseViewModel, BalanceViewModeling, BalanceViewModelingActions {
    typealias Dependencies = HasRequestManager

    let balance: Property<Int>
    let localeBalance: Property<String>
    let getBalance: Action<(),Balance,RequestError>

    // MARK: - Initialization
    init(dependencies: Dependencies) {
        getBalance = Action {
            dependencies.requestManager.getBalance()
        }

        balance = Property<Int>(initial: 0, then: getBalance.values.map { $0.balance })

        localeBalance = Property(initial: " ", then: balance.producer.map { $0.asLocalCurrency() })

        super.init()

        setupBindings()
    }

    func setupBindings() {
        balance.producer.startWithValues { value in
            if let userDefaults = UserDefaults(suiteName: "group.eu.cz.babacros.ISICbalance") {
                userDefaults.set(value, forKey: "balance")
            }
        }
    }
}
