//
//  AccountViewController.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 11/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit
import SnapKit
import SwiftKeychainWrapper
import ACKategories

class AccountViewController: BaseViewController {
    private var viewModel: AccountViewModel
    
    weak var formStackView: UIStackView!
    weak var usernameLabel: UILabel!
    weak var usernameTextField: UITextField!
    weak var passwordLabel: UILabel!
    weak var passwordTextField: UITextField!
    weak var loginButton: UIButton!
    
    override init() {
        self.viewModel = AccountViewModel()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.Theme.backgroundColor

        let formStackView = UIStackView()
        formStackView.spacing = 10
        formStackView.alignment = .leading
        formStackView.axis = .vertical
        self.view.addSubview(formStackView)
        self.formStackView = formStackView
        
        formStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualTo(20)
            make.trailing.lessThanOrEqualTo(-20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        setupFormFields()
        setupLoginButton()
    }
    
    fileprivate func setupFormFields() {
        let usernameLabel = UILabel()
        usernameLabel.text = L10n.Login.username

        usernameLabel.textColor = UIColor.Theme.labelBlue
        self.usernameLabel = usernameLabel
        formStackView.addArrangedSubview(usernameLabel)
        
        let usernameTextField = FormTextField()
        self.usernameTextField = usernameTextField
        formStackView.addArrangedSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(45)
        }
        
        let passwordLabel = UILabel()
        passwordLabel.text = L10n.Login.password
        passwordLabel.textColor = UIColor.Theme.labelBlue
        self.passwordLabel = passwordLabel
        formStackView.addArrangedSubview(passwordLabel)
        
        let passwordTextField = FormTextField()
        self.passwordTextField = passwordTextField
        formStackView.addArrangedSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(45)
        }
    }
    
    fileprivate func setupLoginButton() {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle(L10n.Login.login, for: .normal)
        loginButton.setTitleColor(UIColor.Theme.backgroundColor, for: .normal)
        loginButton.setBackgroundImage(UIColor.Theme.labelBlue.image(), for: .normal)
        self.loginButton = loginButton
        formStackView.addArrangedSubview(loginButton)
        
        loginButton.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(45)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L10n.Login.title
        loginButton.addTarget(self, action: #selector(saveCredentials), for: .touchDown)
    }
    
    @objc func saveCredentials() {
        viewModel.saveCredentials(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
    }
}


