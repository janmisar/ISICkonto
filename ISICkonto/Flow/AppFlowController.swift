//
//  AppFlowController.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 14/02/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol AppFlowControllerProtocol {
    var navigationController: UINavigationController { get }
}

class AppFlowController : AppFlowControllerProtocol {
    
    let navigationController: UINavigationController
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func launch() {
        if true {
            showLoginViewController()
        } else {
            
        }
    }
    
    public func showLoginViewController() {
        let loginViewController = LogInViewController()
        navigationController.show(loginViewController, sender: self)
        
        loginViewController.onLoginSuccess = { [unowned self] in
            self.pushBalanceViewController(with: $0)
        }
    }
    
    public func pushBalanceViewController(with page: String?) {
        let balanceViewController = BalanceViewController()
        if let page = page {
            (balanceViewController.viewModel as! BalanceViewModel).balancePage.value = page
        }
        navigationController.pushViewController(balanceViewController, animated: true)
        
        balanceViewController.onPopBalanceViewController = { [unowned self] in
            self.navigationController.popViewController(animated: true)
        }
    }
}
