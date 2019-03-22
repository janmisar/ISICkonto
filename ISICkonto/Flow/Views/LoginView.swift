//
//  LoginView.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 21/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import UIKit

class LoginView: AppView {
    
    let logo: UIImageView = UIImageView()
    let usernameTextField: FormField = FormField()
    let passwordTextField: FormField = FormField()
    let loginButton: UIButton = UIButton()
    
    override func setupUI() {
        backgroundColor = UIColor(red: 93/255, green: 149/255, blue: 170/255, alpha: 1)
        
        logo.image = UIImage(id: .logo)
        
        passwordTextField.textContentType = UITextContentType.password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "password".localized
        
        usernameTextField.textContentType = UITextContentType.username
        usernameTextField.placeholder = "username".localized
        
        loginButton.setTitle("Log In".localized, for: .normal)
        loginButton.setTitleColor(UIColor(red: 86/255, green: 129/255, blue: 154/255, alpha: 1), for: .normal)
        loginButton.titleLabel?.font = .cabinRegular(size: 17)
        loginButton.backgroundColor = UIColor.white
        loginButton.layer.cornerRadius = 5.0
        
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(logo)
    }
    
    override func createConstraints() {
        logo.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(100)
            make.trailing.equalTo(self).offset(-100)
            make.height.equalTo(logo.snp.width)
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(logo.snp.bottom).offset(30)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
        }
        
        loginButton.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }
    }
}
