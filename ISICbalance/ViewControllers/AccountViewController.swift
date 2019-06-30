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
import SVProgressHUD

protocol AccountFlowDelegate: class {
    func balanceActionCompleted(in viewController: AccountViewController)
}

class AccountViewController: BaseViewController, ValidateErrorPresentable {
    private let viewModel: AccountViewModeling

    private weak var formStackView: UIStackView!
    private weak var usernameLabel: UILabel!
    private weak var usernameTextField: UITextField!
    private weak var passwordLabel: UILabel!
    private weak var passwordTextField: UITextField!
    private weak var loginButton: UIButton!

    weak var flowDelegate: AccountFlowDelegate?

    // MARK: - Initialization
    init(viewModel: AccountViewModeling) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Controller lifecycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.theme.backgroundColor

        let formStackView = UIStackView()
        formStackView.spacing = 10
        formStackView.axis = .vertical
        view.addSubview(formStackView)
        self.formStackView = formStackView
        
        formStackView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
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
        usernameLabel.textColor = UIColor.theme.labelBlue
        self.usernameLabel = usernameLabel
        formStackView.addArrangedSubview(usernameLabel)
        
        let usernameTextField = UITextField.theme.formTextField
        self.usernameTextField = usernameTextField
        formStackView.addArrangedSubview(usernameTextField)
        
        let passwordLabel = UILabel()
        passwordLabel.text = L10n.Login.password
        passwordLabel.textColor = UIColor.theme.labelBlue
        self.passwordLabel = passwordLabel
        formStackView.addArrangedSubview(passwordLabel)
        
        let passwordTextField = UITextField.theme.formTextField
        self.passwordTextField = passwordTextField
        formStackView.addArrangedSubview(passwordTextField)
    }
    
    fileprivate func setupLoginButton() {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle(L10n.Login.login, for: .normal)
        loginButton.setTitleColor(UIColor.theme.backgroundColor, for: .normal)
        loginButton.setBackgroundImage(UIColor.theme.labelBlue.image(), for: .normal)
        self.loginButton = loginButton
        formStackView.addArrangedSubview(loginButton)
        
        loginButton.snp.makeConstraints { (make) in
            make.height.equalTo(45)
        }
    }

    // MARK: - Bindings
    private func setupBindings() {
        usernameTextField <~> viewModel.username
        passwordTextField <~> viewModel.password
        loginButton.reactive.isEnabled <~ viewModel.actions.login.isExecuting.negate()
        
        viewModel.actions.login.errors
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                self?.presentValidationError(L10n.Validate.errorMessage)
            }

        viewModel.actions.login.completed.producer
            .observe(on: UIScheduler())
            .startWithValues { [weak self] in
            self?.flowDelegate?.balanceActionCompleted(in: self!)
        }
    }

    // MARK: - Actions
    @objc
    private func saveCredentials() {
        viewModel.actions.login.apply().start()
    }
}
