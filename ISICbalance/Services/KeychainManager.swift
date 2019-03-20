//
//  KeychainManager.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 16/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation
import ReactiveSwift
import SwiftKeychainWrapper
import Result

class KeychainManager {
    func saveCredentials(username: String, password: String) -> SignalProducer<(),LoginError> {
        //TODO: disposable parameter?
        return SignalProducer { observer, _ in
            let saveUsername: Bool = KeychainWrapper.standard.set(username, forKey: "username")
            let savePassword: Bool = KeychainWrapper.standard.set(password, forKey: "password")

            if saveUsername && savePassword {
                print("saved")
                observer.sendCompleted()
            } else {
                observer.send(error: LoginError.keychainCredentialsFailed)
            }
        }
    }

    func getCredentialsFromKeychain() -> SignalProducer<User, NoError> {
        //TODO: disposable parameter?
        return SignalProducer<User, NoError> { observer, _ in
            let username = KeychainWrapper.standard.string(forKey: "username") ?? ""
            let password = KeychainWrapper.standard.string(forKey: "password") ?? ""
            let user = User(username: username, password: password)

            observer.send(value: user)
            observer.sendCompleted()
        }
    }
}
