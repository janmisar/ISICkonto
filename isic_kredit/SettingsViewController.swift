//
//  ViewController.swift
//  isic_kredit
//
//  Created by Petr Dusek on 07/11/2018.
//  Copyright © 2018 Petr Dusek. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class SettingsViewController: UIViewController {
    
    weak var username: UITextField!
    weak var password: UITextField!
    weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view,d typically from a nib.
        
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor(red:0.27, green:0.60, blue:0.72, alpha:1.0)
        
        let usernameLabel = UILabel()
        usernameLabel.text = "Uživatelské jméno"
        usernameLabel.textColor = UIColor(red:0.67, green:0.84, blue:0.95, alpha:1.0)
        usernameLabel.font = UIFont(name: "Helvetica Neue", size: 17)
        
        let username = UITextField()
        username.backgroundColor = UIColor(red:0.22, green:0.51, blue:0.63, alpha:1.0)
        username.textColor = .white
        self.username = username
        
        let passwordLabel = UILabel()
        passwordLabel.text = "Heslo"
        passwordLabel.textColor = UIColor(red:0.67, green:0.84, blue:0.95, alpha:1.0)
        passwordLabel.font = UIFont(name: "Helvetica Neue", size: 17)
        
        let password = UITextField()
        password.backgroundColor = UIColor(red:0.22, green:0.51, blue:0.63, alpha:1.0)
        password.textColor = .white
        self.password = password
        
        let loginButton = UIButton()
        loginButton.backgroundColor = UIColor(red:0.57, green:0.86, blue:1.00, alpha:1.0)
        loginButton.setTitle("Přihlásit se", for: .normal)
        loginButton.setTitleColor(UIColor(red:0.29, green:0.59, blue:0.70, alpha:1.0), for: .normal)
    
        let mainStack = UIStackView(arrangedSubviews: [usernameLabel, username, passwordLabel, password, loginButton])
        mainStack.spacing = 10
        mainStack.distribution = .fillEqually
        mainStack.axis = .vertical
        view.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
             make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
}
