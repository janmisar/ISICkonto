//
//  LoginViewModel.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 16/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SVProgressHUD
import SwiftKeychainWrapper

class LoginViewModel: AppViewModel {
    
    var username: Variable<String> = Variable("")
    var password: Variable<String> = Variable("")
    var loginAction: Variable<Void> = Variable(())
    
    var isLoginEnabled: Observable<Bool> {
        return Observable.combineLatest(username.asObservable(), password.asObservable()) { !$0.isEmpty && !$1.isEmpty }
    }
    
    var isLoginSuccess: Observable<Bool> {
        return resultRequestLogin.map { [weak self] in
            guard let strongSelf = self, $0.info == .loggedIn else { return false }
            strongSelf.save(credentials: (username: strongSelf.username.value, password: strongSelf.password.value))
            return true
        }.filter{ $0 }
    }
    
    private var credentials: Observable<Credentials> {
        return loginAction.asObservable().withLatestFrom(isLoginEnabled).filter { $0 }.map { [weak self] _ -> Credentials in
            return Credentials(username: (self?.username.value)!, password: (self?.password.value)!)
        }
    }

    private var resultRequestLogin: Observable<Result<String>> {
        return credentials.flatMapLatest { [weak self] (credentials) -> Observable<Result<String>> in
            return (self?.request(credentials: credentials))!
        }
    }
    
    private func request(credentials: Credentials) -> Observable<Result<String>> {
        return WebScrapingService.authenticate(credentials).request()
    }
    
    private func save(credentials: Credentials) {
        KeychainWrapper.standard.set(credentials.username, forKey: "username")
        KeychainWrapper.standard.set(credentials.password, forKey: "password")
    }
    
}
