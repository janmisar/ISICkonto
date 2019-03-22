//
//  BalanceView.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 21/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import UIKit

class BalanceView: AppView {
    
    let balanceLabel: UILabel = UILabel()
    let textLabel: UILabel = UILabel()
    let refreshButton: UIButton = UIButton()
    let logOutButton: UIButton = UIButton()
    let buttonView: UIView = UIView()
    

    override func setupUI() {
        
        backgroundColor = UIColor(red: 93/255, green: 149/255, blue: 170/255, alpha: 1)
        
        balanceLabel.textAlignment = .center
        balanceLabel.font = .cabinBold(size: 85)
        balanceLabel.textColor = UIColor.white
        
        textLabel.textAlignment = .center
        textLabel.font = .cabinRegular(size: 25)
        textLabel.textColor = UIColor(red: 182/255, green: 220/255, blue: 252/255, alpha: 1)
        textLabel.text = "Your balance is".localized
    
        refreshButton.setImage(UIImage(id: .reloadIcon), for: .normal)
        
        logOutButton.setImage(UIImage(id: .accountIcon), for: .normal)
        
        buttonView.addSubview(refreshButton)
        buttonView.addSubview(logOutButton)
        addSubview(buttonView)
        addSubview(balanceLabel)
        addSubview(textLabel)
        
    }
    
    override func createConstraints() {
        textLabel.snp.makeConstraints { make in
            make.bottom.equalTo(balanceLabel.snp.top).offset(-10)
            make.centerX.equalTo(balanceLabel)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        
        buttonView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(balanceLabel.snp.bottom).offset(20)
            make.width.equalTo(150)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(buttonView)
            make.height.width.equalTo(50)
        }
        
        logOutButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalTo(buttonView)
            make.width.height.equalTo(50)
        }
    }
}
