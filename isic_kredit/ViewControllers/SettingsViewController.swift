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
        
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = ColorConstants.backgroundColor
        
        let usernameLabel = UILabel()
        usernameLabel.text = NSLocalizedString("Username", comment: "")
        usernameLabel.textColor = ColorConstants.labelsColor
        usernameLabel.font = FontConstants.labelsFont
        
        let username = UITextField()
        username.backgroundColor = ColorConstants.textFieldColor
        username.textColor = .white
        username.autocapitalizationType = .none
        self.username = username
        
        let passwordLabel = UILabel()
        passwordLabel.text = NSLocalizedString("Password", comment: "")
        passwordLabel.textColor = ColorConstants.labelsColor
        passwordLabel.font = FontConstants.labelsFont
        
        let password = UITextField()
        password.backgroundColor = ColorConstants.textFieldColor
        password.textColor = .white
        password.autocapitalizationType = .none
        password.isSecureTextEntry = true
        self.password = password
        
        let loginButton = UIButton()
        loginButton.backgroundColor = ColorConstants.loginBackgroundColor
        loginButton.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        loginButton.setTitleColor(ColorConstants.textFieldColor, for: .normal)
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
                
                if KeyChain.standard.setUserPassword(user: user, password: psswd){
                    navigationController?.popViewController(animated: true)
                }
                
            }
        }
        
        
    }
    
}
