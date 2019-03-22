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

class BalanceViewModel: BaseViewModel {
    private var requestManager: RequestManager
    lazy var balance = Property<String>.init(initial: "0 Kč", then: getBalanceAction.values.map { $0.balance })

    let getBalanceAction: Action<(),Balance,RequestError>

    override init() {
        self.getBalanceAction = Action {
            return RequestManager.shared.getBalance()
        }

        self.requestManager = RequestManager.shared
        super.init()
    }
}
