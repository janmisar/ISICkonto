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
import ReactiveSwift
import ACKReactiveExtensions
import ACKategories

class AccountViewController: BaseViewController, ValidateErrorPresentable {
    private let viewModel: AccountViewModel

    private weak var formStackView: UIStackView!
    private weak var usernameLabel: UILabel!
    private weak var usernameTextField: UITextField!
    private weak var passwordLabel: UILabel!
    private weak var passwordTextField: UITextField!
    private weak var loginButton: UIButton!

    // MARK: - Initialization
    override init() {
        // TODO: nedostatečný DI
        self.viewModel = AccountViewModel(dependencies: AppDependency.shared)

        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Controller lifecycle
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.Theme.backgroundColor // TODO: fuck self

        let formStackView = UIStackView()
        formStackView.spacing = 10
        formStackView.axis = .vertical
        self.view.addSubview(formStackView) // TODO: fuck self
        self.formStackView = formStackView
        
        formStackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20) // TODO: fuck self
            make.bottom.lessThanOrEqualTo(-20)
        }
        
        setupFormFields()
        setupLoginButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L10n.Login.title
        loginButton.addTarget(self, action: #selector(saveCredentials), for: .touchUpInside)
        setupBindings()
    }

    // MARK: - UI setup
    fileprivate func setupFormFields() {
        let usernameLabel = UILabel()
        usernameLabel.text = L10n.Login.username
        usernameLabel.textColor = UIColor.Theme.labelBlue
        self.usernameLabel = usernameLabel
        formStackView.addArrangedSubview(usernameLabel)
        
        let usernameTextField = FormTextField()
        self.usernameTextField = usernameTextField
        formStackView.addArrangedSubview(usernameTextField)
        
        let passwordLabel = UILabel()
        passwordLabel.text = L10n.Login.password
        passwordLabel.textColor = UIColor.Theme.labelBlue
        self.passwordLabel = passwordLabel
        formStackView.addArrangedSubview(passwordLabel)
        
        let passwordTextField = FormTextField()
        self.passwordTextField = passwordTextField
        formStackView.addArrangedSubview(passwordTextField)
    }
    
    fileprivate func setupLoginButton() {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle(L10n.Login.login, for: .normal)
        loginButton.setTitleColor(UIColor.Theme.backgroundColor, for: .normal)
        loginButton.setBackgroundImage(UIColor.Theme.labelBlue.image(), for: .normal)
        self.loginButton = loginButton
        formStackView.addArrangedSubview(loginButton)
        
        loginButton.snp.makeConstraints { (make) in
            make.height.equalTo(45)
        }
    }

    // MARK: - Bindings
    func setupBindings() {
        usernameTextField <~> viewModel.username
        passwordTextField <~> viewModel.password
        loginButton.reactive.isEnabled <~ viewModel.loginAction.isExecuting.negate()
        
        viewModel.loginAction.errors
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                self?.presentValidationError("You must fill out all fields.")
            }

        viewModel.loginAction.completed.producer.startWithValues { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Actions
    @objc func saveCredentials() {
        viewModel.loginAction.apply().start()
    }
}
