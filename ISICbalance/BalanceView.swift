//
//  BalanceView.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 11/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit

class BalanceView: UIView {

    weak var screenStackView: UIStackView?
    weak var balanceLabel: UILabel?
    weak var balanceTitle: UILabel?
    weak var reloadButton: UIButton?
    weak var accountButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.MyTheme.backgroundColor
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 60
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        let balanceTitle = UILabel()
        balanceTitle.text = L10n.Balance.title
        balanceTitle.textColor = UIColor.MyTheme.labelBlue
        balanceTitle.textAlignment = .center
        balanceTitle.font = UIFont.systemFont(ofSize: 18)
        self.balanceTitle = balanceTitle
        stackView.addArrangedSubview(balanceTitle)
        
        let balanceLabel = UILabel()
        balanceLabel.text = "1357 Kč"
        balanceLabel.textColor = UIColor.MyTheme.textColor
        balanceLabel.adjustsFontSizeToFitWidth = true
        balanceLabel.textAlignment = .center
        balanceLabel.font = UIFont.boldSystemFont(ofSize: 80)
        self.balanceLabel = balanceLabel
        stackView.addArrangedSubview(balanceLabel)
        
        let buttonsStackView = UIStackView()
        buttonsStackView.spacing = 100
        stackView.addArrangedSubview(buttonsStackView)
        
        let reloadButton = UIButton()
        reloadButton.setImage(UIImage(asset: Asset.reloadIcon), for: .normal)
        self.reloadButton = reloadButton
        buttonsStackView.addArrangedSubview(reloadButton)
        
        let spacerView = UIView()
        buttonsStackView.addArrangedSubview(spacerView)
        
        let accountButton = UIButton()
        accountButton.setImage(UIImage(asset: Asset.accountIcon), for: .normal)
        accountButton.isUserInteractionEnabled = true
        self.accountButton = accountButton
        buttonsStackView.addArrangedSubview(accountButton)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
