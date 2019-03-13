//
//  AccountView.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 11/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit

class AccountView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.MyTheme.backgroundColor
        
        let formStackView = UIStackView()
        formStackView.spacing = 10
        formStackView.alignment = .leading
        formStackView.axis = .vertical
        self.addSubview(formStackView)
        
        formStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
        
        let usernameLabel = UILabel()
        usernameLabel.text = L10n.Login.username
        usernameLabel.textColor = UIColor.MyTheme.labelBlue
        formStackView.addArrangedSubview(usernameLabel)
        
        let usernameTextField = UITextField()
        usernameTextField.backgroundColor = UIColor.MyTheme.textFieldBackground
        usernameTextField.textColor = UIColor.MyTheme.textColor
        usernameTextField.tintColor = UIColor.MyTheme.textColor
        usernameTextField.setLeftPaddingPoints(5)
        usernameTextField.layer.cornerRadius = 2
        usernameTextField.layer.masksToBounds = true
        formStackView.addArrangedSubview(usernameTextField)
        
        usernameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(45)
        }
        
        let passwordLabel = UILabel()
        passwordLabel.text = L10n.Login.password
        passwordLabel.textColor = UIColor.MyTheme.labelBlue
        formStackView.addArrangedSubview(passwordLabel)
        
        let passwordTextField = UITextField()
        passwordTextField.backgroundColor = UIColor.MyTheme.textFieldBackground
        passwordTextField.textColor = UIColor.MyTheme.textColor
        passwordTextField.tintColor = UIColor.MyTheme.textColor
        passwordTextField.setLeftPaddingPoints(5)
        passwordTextField.layer.cornerRadius = 2
        passwordTextField.layer.masksToBounds = true
        formStackView.addArrangedSubview(passwordTextField)
        
        passwordTextField.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(45)
        }
        
        let loginButton = UIButton()
        loginButton.setTitle(L10n.Login.login, for: .normal)
        loginButton.setTitleColor(UIColor.MyTheme.backgroundColor, for: .normal)
        loginButton.backgroundColor = UIColor.MyTheme.labelBlue
        formStackView.addArrangedSubview(loginButton)
        
        loginButton.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(45)
        }
        
        let picturesStackView = UIStackView()
        self.addSubview(picturesStackView)
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
