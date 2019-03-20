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
    let keychainManager: KeychainManager
    let username = MutableProperty<String>("")
    let password = MutableProperty<String>("")
    var validationSignal: Property<Bool>
    var validationErrors: Property<[LoginValidation]>

    lazy var loginAction = Action<(),(),LoginError> { [unowned self] in
        if self.validationSignal.value {
            return self.keychainManager.saveCredentials(username: self.username.value, password: self.password.value)
        } else {
            return SignalProducer<(), LoginError>(error: .validation(self.validationErrors.value))
        }
    }

    init(_ keychainManager: KeychainManager) {
        validationErrors = username.combineLatest(with: password).map { username, password in
            var validations: [LoginValidation] = []
            if username.isEmpty {
                validations.append(.username)
            }
            if password.isEmpty {
                validations.append(.password)
            }
            return validations
        }
        
        validationSignal = validationErrors.map { $0.isEmpty }
        self.keychainManager = keychainManager

        super.init()
        keychainManager.getCredentialsFromKeychain().on(value: { [weak self] user in
            self?.username.value = user.username
            self?.password.value = user.password
        }).start()
    }
}
