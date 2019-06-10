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
    var login: Action<(),(),LoginError> { get }
}

extension AccountViewModelingActions where Self: AccountViewModeling {
    var actions: AccountViewModelingActions { return self }
}

final class AccountViewModel: BaseViewModel, AccountViewModeling, AccountViewModelingActions {
    typealias Dependencies = HasKeychainManager

    let username: MutableProperty<String>
    let password: MutableProperty<String>

    let login: Action<(),(),LoginError>

    // MARK: - Initialization
    init(dependencies: Dependencies) {
        username = MutableProperty("")
        password = MutableProperty("")

        let validationErrors: Property<[LoginValidation]> = username.combineLatest(with: password).map { username, password in
            var validations: [LoginValidation] = []
            if username.isEmpty {
                validations.append(.username(message: "Error - username is incorrect"))
            }
            if password.isEmpty {
                validations.append(.password(message: "Error - password is incorrect"))
            }
            return validations
        }

        login = Action(state: Property.combineLatest(username, password, validationErrors)) { stateParameters in
            let (username, password, validationErrors) = stateParameters

            if validationErrors.isEmpty {
                return dependencies.keychainManager.saveCredentials(username: username, password: password)
            } else {
                return SignalProducer<(), LoginError>(error: LoginError.validation(message: L10n.Validate.errorMessage))
            }
        }

        super.init()

        let userCredentials = dependencies.keychainManager.getCredentialsFromKeychain()
        self.username <~ userCredentials.map { $0.username }
        self.password <~ userCredentials.map { $0.password }
    }
}
