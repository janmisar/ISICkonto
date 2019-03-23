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
    private let keychainManager: KeychainManager
    let username = MutableProperty<String>("")
    let password = MutableProperty<String>("")
    private var validationSignal: Property<Bool>
    private var validationErrors: Property<[LoginValidation]>

    lazy var loginAction = Action<(),(),LoginError> { [weak self] in
        guard let self = self else {
            return SignalProducer<(), LoginError>(error: LoginError.actionError(message: "Error - self in loginAction is nil"))
        }
        
        if self.validationSignal.value {
            return self.keychainManager.saveCredentials(username: self.username.value, password: self.password.value)
        } else {
            return SignalProducer<(), LoginError>(error: .validation(self.validationErrors.value))
        }
    }

    override init() {
        validationErrors = username.combineLatest(with: password).map { username, password in
            var validations: [LoginValidation] = []
            if username.isEmpty {
                validations.append(.username(message: "Error - username is incorrect"))
            }
            if password.isEmpty {
                validations.append(.password(message: "Error - password is incorrect"))
            }
            return validations
        }
        
        validationSignal = validationErrors.map { $0.isEmpty }
        self.keychainManager = KeychainManager.shared

        super.init()
        // TODO:
        keychainManager.getCredentialsFromKeychain().on(value: { [weak self] user in
            self?.username.value = user.username
            self?.password.value = user.password
        }).start()
    }
}
