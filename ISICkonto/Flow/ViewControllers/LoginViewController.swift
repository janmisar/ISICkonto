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
    private var usernameTF: FormField!
    private var passwordTF: FormField!
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
        usernameTF = FormField()
        passwordTF = FormField()
        loginButton = UIButton()
        
        passwordTF.textContentType = UITextContentType.password
        passwordTF.isSecureTextEntry = true
        
        usernameTF.textContentType = UITextContentType.username
        
        usernameTF.placeholder = "username".localized
        passwordTF.placeholder = "password".localized
        loginButton.setTitle("Log In".localized, for: .normal)
        loginButton.setTitleColor(UIColor(red: 86/255, green: 129/255, blue: 154/255, alpha: 1), for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Cabin-Regular", size: 17)!
        loginButton.backgroundColor = UIColor.white
        loginButton.layer.cornerRadius = 5.0
        logo.image = UIImage(named: "logo")
        
        view.addSubview(usernameTF)
        view.addSubview(passwordTF)
        view.addSubview(loginButton)
        view.addSubview(logo)
    }
    
    func createConstraints() {
        logo.snp.makeConstraints { make in
            make.left.equalTo(view).offset(100)
            make.right.equalTo(view).offset(-100)
            make.height.equalTo(logo.snp.width)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        usernameTF.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(logo.snp.bottom).offset(30)
        }
        
        passwordTF.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(usernameTF.snp.bottom).offset(20)
        }
        
        loginButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(50)
            make.top.equalTo(passwordTF.snp.bottom).offset(20)
        }
    }
}
