//
//  AccountViewModel.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 15/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import SwiftKeychainWrapper

class AccountViewModel: BaseViewModel {
    
    let username = MutableProperty<String>("")
    let password = MutableProperty<String>("")
    
    var validationSignal: Signal<Bool, NoError>
    
    lazy var loginAction = Action<(), User, LoginError> {
        return .empty
    }
    
    lazy var canSubmitForm: Property<Bool> = Property<Bool>(initial: false, then: validationSignal.producer.and(loginAction.isExecuting.negate()))
    
    override init() {
        validationSignal = username.combineLatest(with: password).signal.map { username, password in
            (!username.isEmpty && !password.isEmpty)
        }
    }
    
    func saveCredentials() {
        let saveUsername: Bool = KeychainWrapper.standard.set(username.value, forKey: "username")
        let savePassword: Bool = KeychainWrapper.standard.set(password.value, forKey: "password")
        
        if saveUsername && savePassword {
            #warning("Push balance VC")
        } else {
            #warning("Show Error Message")
            print("KeychainWrapper save error")
        }
    }
}
