//
//  ViewController.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 07/02/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import UIKit
import SnapKit

class LogInViewController: UIViewController {
    
    private var logo: UIImageView!
    private var usernameTextField: FormField!
    private var passwordTextField: FormField!
    private var loginButton: UIButton!
    
    var onLoginSuccess: (String) -> () = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        createConstraints()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor(red: 93/255, green: 149/255, blue: 170/255, alpha: 1)
        
        logo = UIImageView()
        logo.image = UIImage(named: "logo")
        
        passwordTextField = FormField()
        passwordTextField.textContentType = UITextContentType.password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "password".localized
        
        usernameTextField = FormField()
        usernameTextField.textContentType = UITextContentType.username
        usernameTextField.placeholder = "username".localized
        
        loginButton = UIButton()
        loginButton.setTitle("Log In".localized, for: .normal)
        loginButton.setTitleColor(UIColor(red: 86/255, green: 129/255, blue: 154/255, alpha: 1), for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Cabin-Regular", size: 17)!
        loginButton.backgroundColor = UIColor.white
        loginButton.layer.cornerRadius = 5.0
        
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(logo)
    }
    
    func createConstraints() {
        logo.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(100)
            make.trailing.equalTo(view).offset(-100)
            make.height.equalTo(logo.snp.width)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(logo.snp.bottom).offset(30)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
        }
        
        loginButton.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }
    }
}
