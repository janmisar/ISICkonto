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

    lazy var getBalanceAction = Action<(),Balance,RequestError> { [weak self] in
        if let self = self {
            return self.requestManager.getBalance()
        } else {
            return SignalProducer<Balance, RequestError>(error: RequestError.actionError(message: "Error - self in getBalanceAction is nil"))
        }
    }

    init(_ requestManager: RequestManager) {
        self.requestManager = requestManager
        super.init()
    }
}
