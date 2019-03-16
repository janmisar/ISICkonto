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
import UIKit

class BalanceViewModel: BaseViewModel {
    
    private var requestManager: RequestManager
    let balance = MutableProperty<String>("0 Kč")
    
    init(_ requestManager: RequestManager) {
        self.requestManager = requestManager
        super.init()
        
        requestManager.currentBalance.producer.skipNil().startWithValues { [unowned self] user in
            self.balance.value = user.balance
        }
    }
}
