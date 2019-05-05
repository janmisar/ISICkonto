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

    lazy var balance = Property<Int>(initial: 0, then: getBalance.values.map { $0.balance }) // TODO: možná spíš vracet číslo než string -> Opravdu to mám převádět pomocí formatteru do double a pak to zase formátovat do double s čárkou?
    let getBalance: Action<(),Balance,RequestError>

    // MARK: - Initialization
    init(dependencies: Dependencies) {
        self.getBalance = Action {
            dependencies.requestManager.getBalance()
        }

        super.init()
    }
}
