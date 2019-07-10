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

class LogInViewController: AppViewController<LoginViewModel, LoginView> {
 
    var onLoginSuccess: () -> () = { }
    
    override func setView() {
        view = LoginView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        v.constraintSmallLogo()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        v.animateLogo()
    }
    
    override func setupOutputBindings(to vm: LoginViewModel) {
        (v.usernameTextField >>> vm.username).disposed(by: disposeBag)
        (v.passwordTextField >>> vm.password).disposed(by: disposeBag)
        (v.loginButton       >>> vm.loginAction).disposed(by: disposeBag)
        
        v.loginButton.rx.tap.bind { [unowned self] in
            print("what")
            self.v.showLoading(with: "Loading balance...".localized)
            }.disposed(by: disposeBag)
    }
    
    override func setupInputBindings(from vm: LoginViewModel) {
        (vm.isLoginSuccess --> { [unowned self] success in
            if !success { self.v.showError(with: "Wrong credentials".localized) }
            else {
                self.v.showSuccess(with: "Success!".localized)
                self.onLoginSuccess()
            }
            self.v.usernameTextField.deactivate()
            self.v.passwordTextField.deactivate()
            }).disposed(by: disposeBag)
        
        (vm.isLoginEnabled --> { [unowned self] in
            self.v.loginButton.set(alpha: $0 ? 1.0 : 0.2)
            }).disposed(by: disposeBag)
    }
}
