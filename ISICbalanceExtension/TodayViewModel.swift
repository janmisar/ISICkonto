//
//  TodayViewModel.swift
//  ISICbalanceExtension
//
//  Created by Rostislav Babáček on 25/06/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation
import ReactiveSwift
import UIKit

protocol TodayViewModeling {
    var balance: Property<Int> { get }
    var localeBalance: Property<String> { get }
    var actions: TodayViewModelingActions { get }
}

protocol TodayViewModelingActions {
    var getBalance: Action<Void,Balance,RequestError> { get }
}

extension TodayViewModelingActions where Self: TodayViewModeling {
    var actions: TodayViewModelingActions { return self }
}

final class TodayViewModel: BaseViewModel, TodayViewModeling, TodayViewModelingActions {
    typealias Dependencies = HasRequestManager

    let balance: Property<Int>
    let localeBalance: Property<String>
    let getBalance: Action<Void,Balance,RequestError>

    // MARK: - Initialization
    init(dependencies: Dependencies) {
        getBalance = Action {
            dependencies.requestManager.getBalance()
        }

        balance = Property<Int>(initial: 0, then: getBalance.values.map { $0.balance })

        localeBalance = Property<String>(initial: " ", then: balance.producer.map { $0.asLocalCurrency() })

        super.init()
    }
}
