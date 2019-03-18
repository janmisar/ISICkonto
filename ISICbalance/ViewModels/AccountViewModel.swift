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
    var validationSignal: Property<Bool>
    var validationErrors: Property<[LoginValidation]>

    
    lazy var loginAction = Action<(),(),LoginError> { [unowned self] in
        if self.validationSignal.value {
            return self.saveCredentials()
        } else {
            return SignalProducer<(), LoginError>(error: .validation(self.validationErrors.value))
        }
    }

    override init() {
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
    }
    
    func getCredentialsFromKeychain() {
        #warning("TODO: create KeychainManager")
        username.value = KeychainWrapper.standard.string(forKey: "username") ?? ""
        password.value = KeychainWrapper.standard.string(forKey: "password") ?? ""
    }
    
    func saveCredentials() -> SignalProducer<(),LoginError> {
        #warning("TODO: create KeychainManager")
        return SignalProducer { [weak self] observer, disposable in
            let saveUsername: Bool = KeychainWrapper.standard.set(self?.username.value ?? "", forKey: "username")
            let savePassword: Bool = KeychainWrapper.standard.set(self?.password.value ?? "", forKey: "password")

            if saveUsername && savePassword {
                observer.sendCompleted()
            } else {
                observer.send(error: LoginError.keychainCredentialsFailed)
            }
        }
    }
}
