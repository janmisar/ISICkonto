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
    
    var loginEnabled: Observable<Bool> {
        return Observable.combineLatest(username.asObservable(), password.asObservable()) { !$0.isEmpty && !$1.isEmpty }
    }
    
    var requestBalance: Observable<Credentials> {
        return loginAction.asObservable().withLatestFrom(loginEnabled).filter { $0 }.map { [weak self] _ -> Credentials in print("Request login");
            return Credentials(username: (self?.username.value)!, password: (self?.password.value)!)
        }
    }

    var resultRequestBalancePage: Observable<Result<String>> {
        return requestBalance.flatMapLatest { [weak self] (credentials) -> Observable<Result<String>> in
            SVProgressHUD.show(withStatus: "Loading balance...".localized)
            return (self?.request(credentials: credentials))!
        }
    }
    
    var balancePageString: Observable<String> {
        return resultRequestBalancePage.map { [weak self] in
            guard let strongSelf = self, let balancePage = $0.element, $0.info == .loggedIn else {
                SVProgressHUD.showError(withStatus: "Wrong credentials".localized)
                SVProgressHUD.dismiss(withDelay: 1.0)
                return ""
            }
            SVProgressHUD.showSuccess(withStatus: "Success!")
            SVProgressHUD.dismiss(withDelay: 1.0)
            strongSelf.save(credentials: (username: strongSelf.username.value, password: strongSelf.password.value))
            return balancePage
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
