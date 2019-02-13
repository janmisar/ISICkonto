//
//  KeyChain.swift
//  isic_kredit
//
//  Created by Petr Dusek on 12/02/2019.
//  Copyright © 2019 Petr Dusek. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class KeyChain {
    
    func getUsername() -> String{
        if let username = KeychainWrapper.standard.string(forKey: "username") {
            return username
        }
        
        return ""
    }
    
    func getPassword() -> String{
        if let password = KeychainWrapper.standard.string(forKey: "password") {
            return password
        }
        
        return ""
    }
    
    func setUserPassword(user: String, password: String) -> Bool{
        if user != KeychainWrapper.standard.string(forKey: "username") && password != KeychainWrapper.standard.string(forKey: "password") {
            
            if user != "" && password != "" {
                KeychainWrapper.standard.set(user, forKey: "username")
                KeychainWrapper.standard.set(password, forKey: "password")
                
                return true
            }
            
        }
        
        return false
    }
    
}
