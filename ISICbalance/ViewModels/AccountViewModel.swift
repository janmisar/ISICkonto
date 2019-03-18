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
    private var requestManager: RequestManager
    
    let username = MutableProperty<String>("")
    let password = MutableProperty<String>("")
    
    var validationSignal: Property<Bool>
    var validationErrors: Property<[LoginValidation]>
    
//    lazy var loginAction = Action<(),User,LoginError> { [unowned self] in
//        if self.validationSignal.value {
//            return self.requestManager.reloadData()
//        } else {
//            return SignalProducer<User, LoginError>(error: .validation(self.validationErrors.value))
//        }
//    }
    
        lazy var loginAction = Action<(),User,LoginError> { [unowned self] in
            if self.validationSignal.value {
                return self.saveCredentials()
            } else {
                return SignalProducer<User, LoginError>(error: .validation(self.validationErrors.value))
            }
        }

    
    init(_ requestManager: RequestManager) {
        self.requestManager = requestManager
        
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
        username.value = KeychainWrapper.standard.string(forKey: "username") ?? ""
        password.value = KeychainWrapper.standard.string(forKey: "password") ?? ""
    }
    
    func saveCredentials() -> SignalProducer<User,LoginError> {
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
