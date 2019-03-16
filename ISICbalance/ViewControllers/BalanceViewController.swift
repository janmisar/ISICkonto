//
//  BalanceViewController.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 12/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import ReactiveSwift
import ACKReactiveExtensions

class BalanceViewController: BaseViewController {
    private var requestManager: RequestManager
    private var viewModel: BalanceViewModel
    private var accountViewModel: AccountViewModel
    
    weak var screenStackView: UIStackView!
    weak var balanceLabel: UILabel!
    weak var balanceTitle: UILabel!
    weak var reloadButton: UIButton!
    weak var accountButton: UIButton!
    
    override init() {
        let requestManager = RequestManager()
        self.requestManager = requestManager
        self.viewModel = BalanceViewModel(requestManager)
        self.accountViewModel = AccountViewModel(requestManager)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.MyTheme.backgroundColor
        
        let screenStackView = UIStackView()
        screenStackView.axis = .vertical
        screenStackView.spacing = 60
        self.screenStackView = screenStackView
        self.view.addSubview(screenStackView)
        
        screenStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        setupBalanceField()
        setupButtonsStack()
    }
    
    fileprivate func setupBalanceField() {
        let balanceTitle = UILabel()
        balanceTitle.text = L10n.Balance.title
        balanceTitle.textColor = UIColor.MyTheme.labelBlue
        balanceTitle.textAlignment = .center
        balanceTitle.font = UIFont.systemFont(ofSize: 18)
        self.balanceTitle = balanceTitle
        screenStackView.addArrangedSubview(balanceTitle)
        
        let balanceLabel = UILabel()
        balanceLabel.text = "1357 Kč"
        balanceLabel.textColor = UIColor.MyTheme.textColor
        balanceLabel.adjustsFontSizeToFitWidth = true
        balanceLabel.textAlignment = .center
        balanceLabel.font = UIFont.boldSystemFont(ofSize: 80)
        self.balanceLabel = balanceLabel
        screenStackView.addArrangedSubview(balanceLabel)
    }
    
    fileprivate func setupButtonsStack() {
        let buttonsStackView = UIStackView()
        buttonsStackView.spacing = 100
        screenStackView.addArrangedSubview(buttonsStackView)
        
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
        self.accountButton.addTarget(self, action: #selector(accountBtnHandle), for: .touchDown)
        self.reloadButton.addTarget(self, action: #selector(reloadBalance), for: .touchDown)
        setupBindings()
    }
    
    func setupBindings() {
        self.balanceLabel.reactive.text <~ viewModel.balance
    }
    
    @objc func reloadBalance() {
        accountViewModel.loginAction.apply().start()
    }
    
    @objc func accountBtnHandle() {
        let VC = AccountViewController(accountViewModel)
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
