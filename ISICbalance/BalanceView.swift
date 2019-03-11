//
//  BalanceView.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 11/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit

class BalanceView: UIView {

    weak var balanceLabel: UILabel?
    weak var balanceTitle: UILabel?
    weak var reloadButton: UIButton?
    weak var accountButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 75/255, green: 150/255, blue: 179/255, alpha: 1)
        
        let balanceLabel = UILabel()
        balanceLabel.text = "1357 Kč"
        balanceLabel.textColor = UIColor.white
        balanceLabel.adjustsFontSizeToFitWidth = true
        balanceLabel.textAlignment = .center
        balanceLabel.font = UIFont.boldSystemFont(ofSize: 80)
        self.balanceLabel = balanceLabel
        self.addSubview(balanceLabel)
        
        balanceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let balanceTitle = UILabel()
        balanceTitle.text = L10n.Balance.title
        balanceTitle.textColor = UIColor(red: 171/255, green: 213/255, blue: 242/255, alpha: 1)
        balanceTitle.textAlignment = .center
        balanceTitle.font = UIFont.systemFont(ofSize: 18)
        self.balanceTitle = balanceTitle
        self.addSubview(balanceTitle)
        
        balanceTitle.snp.makeConstraints { (make) in
            make.bottom.equalTo(balanceLabel.snp.top).offset(-70)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        let buttonsStackView = UIStackView()
        buttonsStackView.spacing = 100
        self.addSubview(buttonsStackView)
        
        buttonsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(balanceLabel.snp.bottom).offset(70)
            make.centerX.equalToSuperview()
        }
        
        let reloadButton = UIButton()
        reloadButton.setImage(UIImage(asset: Asset.reloadIcon), for: .normal)
        self.reloadButton = reloadButton
        buttonsStackView.addArrangedSubview(reloadButton)
        
        let accountButton = UIButton()
        accountButton.setImage(UIImage(asset: Asset.accountIcon), for: .normal)
        self.accountButton = accountButton
        buttonsStackView.addArrangedSubview(accountButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
