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

protocol AccountViewModeling {
    var username: MutableProperty<String> { get }
    var password: MutableProperty<String> { get }

    var actions: AccountViewModelingActions { get }
}

protocol AccountViewModelingActions {
    var loginAction: Action<(),(),LoginError> { get }
}

extension AccountViewModelingActions where Self: AccountViewModeling {
    var actions: AccountViewModelingActions { return self }
}

class AccountViewModel: BaseViewModel, AccountViewModeling, AccountViewModelingActions {
    typealias Dependencies = HasKeychainManager

    let username: MutableProperty<String>
    let password: MutableProperty<String>
    private var validationSignal: Property<Bool>
    private var validationErrors: Property<[LoginValidation]>

    let loginAction: Action<(),(),LoginError>

    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies

        username = MutableProperty("")
        password = MutableProperty("")

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

        loginAction = Action(state: Property.combineLatest(username, password, validationErrors, validationSignal)) { state in
            let (username, password, validationErrors, validationSignal) = state

            if validationSignal {
                return dependencies.keychainManager.saveCredentials(username: username, password: password)
            } else {
                return SignalProducer<(), LoginError>(error: LoginError.validation(validationErrors))
            }
        }

        super.init()
        // TODO:
        dependencies.keychainManager.getCredentialsFromKeychain().on(value: { [weak self] user in
            self?.username.value = user.username
            self?.password.value = user.password
        }).start()
    }
}
