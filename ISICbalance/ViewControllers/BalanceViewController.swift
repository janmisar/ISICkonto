//
//  BalanceViewController.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 12/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit

class BalanceViewController: BaseViewController {

    weak var screenStackView: UIStackView?
    weak var balanceLabel: UILabel?
    weak var balanceTitle: UILabel?
    weak var reloadButton: UIButton?
    weak var accountButton: UIButton?
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.MyTheme.backgroundColor
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 60
        self.view.addSubview(stackView)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = true
        self.accountButton?.addTarget(self, action: #selector(accountBtnHandle), for: .touchDown)
    }
    
    @objc func accountBtnHandle() {
        let VC = AccountViewController()
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
