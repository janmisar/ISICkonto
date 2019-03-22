//
//  BalanceViewModel.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 21/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation
import RxSwift
import Kanna
import SwiftKeychainWrapper
import SVProgressHUD

class BalanceViewModel: AppViewModel {
    var refreshAction: Variable<Void> = Variable(())
    
    var disposeBag = DisposeBag()
    
    var balance : Observable<String> {
        return resultRequestBalancePage.map { [weak self] in
            guard let strongSelf = self, let balancePage = $0.element, $0.info == .loggedIn else {
                SVProgressHUD.showError(withStatus: "Failed".localized)
                SVProgressHUD.dismiss(withDelay: 1.0)
                return "..."
            }
            SVProgressHUD.dismiss(withDelay: 1.0)
            return strongSelf.scrapeBalance(from: balancePage)
        }
    }
    
    private var requestBalance: Observable<Credentials> {
        return refreshAction.asObservable().map { [weak self] in
            guard let strongSelf = self else { return (username: "", password: "") }
            return strongSelf.getCredentials() }
    }
    
    private var resultRequestBalancePage: Observable<Result<String>> {
        return requestBalance.flatMapLatest { [weak self] (credentials) -> Observable<Result<String>> in
            SVProgressHUD.show(withStatus: "Loading balance...".localized)
            return (self?.request(credentials: credentials))!
        }
    }
    
    private func request(credentials: Credentials) -> Observable<Result<String>> {
        return WebScrapingService.authenticate(credentials).request()
    }
    
    private func scrapeBalance(from html: String) -> String {
        let accountHtml = try? HTML(html: html, encoding: .utf8)
        guard let information = accountHtml?.xpath("//td") else { return "..." }
        var balance = information[4].text!
        balance.removeLast(4)
        print(balance)
        return balance
    }
    
    private func getCredentials() -> Credentials {
        let username = KeychainWrapper.standard.string(forKey: "username")
        let password = KeychainWrapper.standard.string(forKey: "password")
        
        return (username: username ?? "", password: password ?? "")
    }
}
