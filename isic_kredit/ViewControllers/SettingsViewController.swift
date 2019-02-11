//
//  SettingsViewController.swift
//  isic_kredit
//
//  Created by Petr Dusek on 07/11/2018.
//  Copyright © 2018 Petr Dusek. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftKeychainWrapper

class SettingsViewController: UIViewController {
    
    weak var username: UITextField!
    weak var password: UITextField!
    weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        self.title = NSLocalizedString("User", comment: "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.27, green:0.60, blue:0.72, alpha:1.0)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = ColorConstants.BackgroundColor
        
        let usernameLabel = UILabel()
        usernameLabel.text = NSLocalizedString("Username", comment: "")
        usernameLabel.textColor = ColorConstants.LabelsColor
        usernameLabel.font = FontConstants.LabelsFont
        
        let username = UITextField()
        username.backgroundColor = ColorConstants.TextFieldColor
        username.textColor = .white
        username.autocapitalizationType = .none
        self.username = username
        
        let passwordLabel = UILabel()
        passwordLabel.text = NSLocalizedString("Password", comment: "")
        passwordLabel.textColor = ColorConstants.LabelsColor
        passwordLabel.font = FontConstants.LabelsFont
        
        let password = UITextField()
        password.backgroundColor = ColorConstants.TextFieldColor
        password.textColor = .white
        password.autocapitalizationType = .none
        password.isSecureTextEntry = true
        self.password = password
        
        let loginButton = UIButton()
        loginButton.backgroundColor = ColorConstants.LoginBackgroundColor
        loginButton.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        loginButton.setTitleColor(ColorConstants.TextFieldColor, for: .normal)
        self.loginButton = loginButton
    
        let mainStack = UIStackView(arrangedSubviews: [usernameLabel, username, passwordLabel, password, loginButton])
        mainStack.spacing = 10
        mainStack.distribution = .fillEqually
        mainStack.axis = .vertical
        view.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
             make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        
        if let user = username.text{
            
            if let psswd = password.text{
                
                if user != KeychainWrapper.standard.string(forKey: "username") && psswd != KeychainWrapper.standard.string(forKey: "password") {
                    
                    if user != "" && psswd != "" {
                        KeychainWrapper.standard.set(user, forKey: "username")
                        KeychainWrapper.standard.set(psswd, forKey: "password")
                        
                        navigationController?.popViewController(animated: true)
                    }

                }
                
            }
        }
        
        
    }
    
}
