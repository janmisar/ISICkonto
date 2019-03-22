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
 
    var onLoginSuccess: () -> () = { }
    
    override func setView() {
        view = LoginView()
    }
    
    override func setViewModel() {
        viewModel = LoginViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let loginView = view as! LoginView
        
        loginView.logo.snp.makeConstraints { [unowned loginView] make in
            make.leading.equalTo(loginView).offset(50)
            make.trailing.equalTo(loginView).offset(-50)
            make.height.equalTo(loginView.logo.snp.width)
            make.center.equalTo(loginView.snp.center)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let loginView = view as! LoginView
        
        loginView.logo.snp.removeConstraints()
        loginView.logo.snp.makeConstraints { [unowned loginView] make in
            make.leading.equalTo(loginView).offset(100)
            make.trailing.equalTo(loginView).offset(-100)
            make.height.equalTo(loginView.logo.snp.width)
            make.top.equalTo(loginView.safeAreaLayoutGuide).offset(30)
        }
        
        UIView.animate(withDuration: 1) { [unowned loginView] in
            loginView.layoutIfNeeded()
        }
    }
    
    override func bindViewToViewModel(v: UIView, vm: AppViewModel) {
        let loginView = v as! LoginView
        let vm = vm as! LoginViewModel
        
        // Output bindings
        (loginView.usernameTextField >>> vm.username).disposed(by: disposeBag)
        (loginView.passwordTextField >>> vm.password).disposed(by: disposeBag)
        (loginView.loginButton >>> vm.loginAction).disposed(by: disposeBag)
        
        // Input bindings
        (vm.isLoginSuccess --> { [unowned self] _ in
                self.onLoginSuccess()
                loginView.usernameTextField.deactivate()
                loginView.passwordTextField.deactivate()
            }).disposed(by: disposeBag)
        
        (vm.isLoginEnabled --> {
                loginView.loginButton.set(alpha: $0 ? 1.0 : 0.2)
            }).disposed(by: disposeBag)
    }
}
