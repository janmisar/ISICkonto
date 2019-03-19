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
    let balance = MutableProperty<String>("0 Kč")
    
    lazy var getBalanceAction = Action<(),DataResponse<String>,RequestError> { [weak self] in
        if let self = self {
            return self.requestManager.getBalance()
        } else {
            return SignalProducer<DataResponse<String>, RequestError>(error: RequestError.actionError)
        }
    }
    
    init(_ requestManager: RequestManager) {
        self.requestManager = requestManager
        super.init()
        
        requestManager.currentBalance.producer.skipNil().startWithValues { [unowned self] user in
            self.balance.value = user.balance
        }
    }
}
