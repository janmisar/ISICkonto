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
    
    lazy var loginAction = Action<(), User, LoginError> {
        if self.validationSignal.value {
            return .empty
        } else {
            return SignalProducer<User, LoginError>(error: .validation(self.validationErrors.value))
        }
    }
    
    lazy var canSubmitForm: Property<Bool> = Property<Bool>(initial: false, then: validationSignal.producer.and(loginAction.isExecuting.negate()))
    
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
        username.value = KeychainWrapper.standard.string(forKey: "username") ?? ""
        password.value = KeychainWrapper.standard.string(forKey: "password") ?? ""
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
