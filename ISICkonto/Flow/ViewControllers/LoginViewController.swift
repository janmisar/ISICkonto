//
//  ViewController.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 07/02/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import SVProgressHUD

class LogInViewController: AppViewController {
 
    var onLoginSuccess: (String) -> () = { _ in }
    
    override func setView() {
        view = LoginView()
    }
    
    override func setViewModel() {
        viewModel = LoginViewModel()
    }
    
    override func bindViewToViewModel(v: UIView, vm: AppViewModel) {
        let loginView = v as! LoginView
        let vm = vm as! LoginViewModel
        
        // Output bindings
        (loginView.usernameTextField >>> vm.username).disposed(by: disposeBag)
        (loginView.passwordTextField >>> vm.password).disposed(by: disposeBag)
        (loginView.loginButton >>> vm.loginAction).disposed(by: disposeBag)
        
        // Input bindings
        (vm.balancePageString --> {
                $0.isEmpty ? nil : self.onLoginSuccess($0)
                loginView.usernameTextField.deactivate()
                loginView.passwordTextField.deactivate()
            }).disposed(by: disposeBag)
        
        (vm.loginEnabled --> {
                loginView.loginButton.set(alpha: $0 ? 1.0 : 0.2)
            }).disposed(by: disposeBag)
    }
}
