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
    var balance: Property<String> { get }
    
    var actions: BalanceViewModelingActions { get }
}

protocol BalanceViewModelingActions {
    var getBalanceAction: Action<(),Balance,RequestError> { get }
}

extension BalanceViewModelingActions where Self: BalanceViewModeling {
    var actions: BalanceViewModelingActions { return self }
}

final class BalanceViewModel: BaseViewModel, BalanceViewModeling, BalanceViewModelingActions {
    typealias Dependencies = HasRequestManager
    private let dependencies: Dependencies

    lazy var balance = Property<String>(initial: "0 Kč", then: getBalanceAction.values.map { $0.balance })
    let getBalanceAction: Action<(),Balance,RequestError>

    // MARK: - Initialization
    init(dependencies: Dependencies) {
        self.dependencies = dependencies

        self.getBalanceAction = Action {
            return dependencies.requestManager.getBalance()
        }

        super.init()
    }
}
