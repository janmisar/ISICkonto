//
//  AccountViewController.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 11/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import ReactiveSwift
import ACKReactiveExtensions

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
        self.view.backgroundColor = UIColor.MyTheme.backgroundColor
        
        let formStackView = UIStackView()
        formStackView.spacing = 10
        formStackView.alignment = .leading
        formStackView.axis = .vertical
        self.view.addSubview(formStackView)
        self.formStackView = formStackView
        
        formStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        setupFormFields()
        setupLoginButton()
        setupBottomImages()
    }
    
    fileprivate func setupFormFields() {
        let usernameLabel = UILabel()
        usernameLabel.text = L10n.Login.username
        usernameLabel.textColor = UIColor.MyTheme.labelBlue
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
        passwordLabel.textColor = UIColor.MyTheme.labelBlue
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
        let loginButton = UIButton()
        loginButton.setTitle(L10n.Login.login, for: .normal)
        loginButton.setTitleColor(UIColor.MyTheme.backgroundColor, for: .normal)
        loginButton.backgroundColor = UIColor.MyTheme.labelBlue
        self.loginButton = loginButton
        formStackView.addArrangedSubview(loginButton)
        
        loginButton.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(45)
        }
    }
    
    fileprivate func setupBottomImages() {
        let picturesStackView = UIStackView()
        self.view.addSubview(picturesStackView)
        
        picturesStackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        let authorPicture = UIImageView(image: UIImage(asset: Asset.janmisar))
        picturesStackView.addArrangedSubview(authorPicture)
        
        let spacer = UIView()
        picturesStackView.addArrangedSubview(spacer)
        
        let companyPicture = UIImageView(image: UIImage(asset: Asset.mightycreations))
        companyPicture.contentMode = .scaleAspectFit
        picturesStackView.addArrangedSubview(companyPicture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = L10n.Login.title
        
        loginButton.addTarget(self, action: #selector(saveCredentials), for: .touchDown)
        
        setupBindings()
        viewModel.getCredentialsFromKeychain()
    }
    
    @objc func saveCredentials() {
        viewModel.saveCredentials()
    }
    
    func setupBindings() {
        usernameTextField <~> viewModel.username
        passwordTextField <~> viewModel.password
        loginButton.reactive.isEnabled <~ viewModel.canSubmitForm
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}


