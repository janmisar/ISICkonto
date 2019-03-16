//
//  AccountView.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 11/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit
import ACKategories

class AccountView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.Theme.backgroundColor
        
        let formStackView = UIStackView()
        formStackView.spacing = 10
        formStackView.alignment = .leading
        formStackView.axis = .vertical
        self.addSubview(formStackView)
        
        formStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualTo(20)
            make.trailing.lessThanOrEqualTo(-20)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
        
        let usernameLabel = UILabel()
        usernameLabel.text = L10n.Login.username
        usernameLabel.textColor = UIColor.Theme.labelBlue
        formStackView.addArrangedSubview(usernameLabel)
        
        let usernameTextField = FormTextField()
        formStackView.addArrangedSubview(usernameTextField)
        
        usernameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(45)
        }
        
        let passwordLabel = UILabel()
        passwordLabel.text = L10n.Login.password
        passwordLabel.textColor = UIColor.Theme.labelBlue
        formStackView.addArrangedSubview(passwordLabel)
        
        let passwordTextField = FormTextField()
        formStackView.addArrangedSubview(passwordTextField)
        
        passwordTextField.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(45)
        }
        
        let loginButton = UIButton(type: .system)
        loginButton.setTitle(L10n.Login.login, for: .normal)
        loginButton.setTitleColor(UIColor.Theme.backgroundColor, for: .normal)
        loginButton.setBackgroundImage(UIColor.Theme.labelBlue.image(), for: .normal)
        formStackView.addArrangedSubview(loginButton)
        
        loginButton.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(45)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
