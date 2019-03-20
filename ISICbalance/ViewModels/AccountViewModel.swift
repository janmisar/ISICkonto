//
//  AccountViewModel.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 15/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class AccountViewModel: BaseViewModel {
    override init() {
        
    }
    
    func saveCredentials(username: String, password: String) {
        #warning("TODO - create keychain manager")
        let saveUsername: Bool = KeychainWrapper.standard.set(username, forKey: "username")
        let savePassword: Bool = KeychainWrapper.standard.set(password, forKey: "password")
        
        if saveUsername && savePassword {
            #warning("Push balance VC")
        } else {
            #warning("Show Error Message")
            print("KeychainWrapper save error")
        }
    }
}
