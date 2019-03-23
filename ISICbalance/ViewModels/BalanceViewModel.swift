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
    var getBalanceAction: Action<(),Balance,RequestError> { get }
}

class BalanceViewModel: BaseViewModel, BalanceViewModeling {
    typealias Dependencies = HasRequestManager

    lazy var balance = Property<String>.init(initial: "0 Kč", then: getBalanceAction.values.map { $0.balance })
    let getBalanceAction: Action<(),Balance,RequestError>

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies

        self.getBalanceAction = Action {
            return dependencies.requestManager.getBalance()
        }

        super.init()
    }
}
