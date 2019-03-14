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
    
    var navigationController: UINavigationController
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func launch() {
        if true {
            navigationController.show(LogInViewController(), sender: self)
        } else {
            navigationController.show(BalanceViewController(), sender: self)
        }
    }
    
    public func showLoginViewController() {
        
    }
    
    public func pushBalanceViewController(with page: String) {

    }
}
