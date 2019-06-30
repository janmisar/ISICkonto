//
//  KeychainManager.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 18/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation
import ReactiveSwift
import SwiftKeychainWrapper

protocol HasKeychainManager {
    var keychainManager: KeychainManagering { get }
}

protocol KeychainManagering {
    func saveCredentials(username: String, password: String) -> SignalProducer<(),LoginError>
    func getCredentialsFromKeychain() -> SignalProducer<User, Never>
}

final class KeychainManager: KeychainManagering {
    func saveCredentials(username: String, password: String) -> SignalProducer<(),LoginError> {
        return SignalProducer { observer, _ in
            let wrapper = KeychainWrapper(serviceName: "eu.cz.babacros", accessGroup: "eu.cz.babacros.ISICbalance.keychaingroup")
            let saveUsername: Bool = wrapper.set(username, forKey: "username")
            let savePassword: Bool = wrapper.set(password, forKey: "password")

            if saveUsername && savePassword {
                observer.sendCompleted()
            } else {
                observer.send(error: LoginError.keychainCredentialsFailed(message: "Error - saving credentials to keychain failed"))
            }
        }
    }

    func getCredentialsFromKeychain() -> SignalProducer<User, Never> {
        return SignalProducer<User, Never> { observer, _ in
            let wrapper = KeychainWrapper(serviceName: "eu.cz.babacros", accessGroup: "eu.cz.babacros.ISICbalance.keychaingroup")
            let username = wrapper.string(forKey: "username") ?? ""
            let password = wrapper.string(forKey: "password") ?? ""
            let user = User(username: username, password: password)

            observer.send(value: user)
            observer.sendCompleted()
        }
    }
}
