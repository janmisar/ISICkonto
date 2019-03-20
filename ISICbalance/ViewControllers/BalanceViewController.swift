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
import SnapKit

class BalanceViewController: BaseViewController {
    private let requestManager: RequestManager
    private let viewModel: BalanceViewModel
    private let accountViewModel: AccountViewModel

    private let keychainManager: KeychainManager
    
    weak var screenStackView: UIStackView!
    weak var balanceLabel: UILabel!
    weak var balanceTitle: UILabel!
    weak var reloadButton: UIButton!
    weak var accountButton: UIButton!
    
    override init() {
        let keychainManager = KeychainManager()
        self.keychainManager = KeychainManager()
        let requestManager = RequestManager(keychainManager)
        self.requestManager = requestManager
        self.viewModel = BalanceViewModel(requestManager)
        //TODO: waiting for flow coord. lecture
        self.accountViewModel = AccountViewModel(keychainManager)

        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.Theme.backgroundColor
        
        let screenStackView = UIStackView()
        screenStackView.axis = .vertical
        screenStackView.spacing = 60
        self.screenStackView = screenStackView
        self.view.addSubview(screenStackView)
        
        screenStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(50)
            make.top.greaterThanOrEqualTo(30)
            make.bottom.lessThanOrEqualTo(-30)
        }
        
        setupBalanceField()
        setupButtonsStack()
    }
    
    fileprivate func setupBalanceField() {
        let balanceTitle = UILabel()
        balanceTitle.text = L10n.Balance.title
        balanceTitle.textColor = UIColor.Theme.labelBlue
        balanceTitle.textAlignment = .center
        balanceTitle.font = UIFont.systemFont(ofSize: 18)
        self.balanceTitle = balanceTitle
        screenStackView.addArrangedSubview(balanceTitle)
        
        let balanceLabel = UILabel()
        balanceLabel.textColor = UIColor.Theme.textColor
        balanceLabel.adjustsFontSizeToFitWidth = true
        balanceLabel.textAlignment = .center
        balanceLabel.font = UIFont.boldSystemFont(ofSize: 80)
        self.balanceLabel = balanceLabel
        screenStackView.addArrangedSubview(balanceLabel)
    }
    
    fileprivate func setupButtonsStack() {
        let buttonsStackView = UIStackView()
        buttonsStackView.distribution = .fillEqually
        screenStackView.addArrangedSubview(buttonsStackView)

        let reloadButton = UIButton()
        reloadButton.setImage(Asset.reloadIcon.image, for: .normal)
        self.reloadButton = reloadButton
        buttonsStackView.addArrangedSubview(reloadButton)

        let accountButton = UIButton()
        accountButton.setImage(Asset.accountIcon.image, for: .normal)
        accountButton.isUserInteractionEnabled = true
        self.accountButton = accountButton
        buttonsStackView.addArrangedSubview(accountButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.accountButton.addTarget(self, action: #selector(accountBtnHandle), for: .touchUpInside)
        self.reloadButton.addTarget(self, action: #selector(reloadBalance), for: .touchUpInside)
        setupBindings()
    }
    
    func setupBindings() {
        self.balanceLabel.reactive.text <~ viewModel.balance
        // pop viewController if problems with getBalanceAction
        viewModel.getBalanceAction.errors.producer.startWithValues { [weak self] errors in
            self?.accountBtnHandle()
        }
    }
    
    @objc func reloadBalance() {
        // TODO:
        print("RELOAD")
        viewModel.getBalanceAction.apply().start()
    }
    
    @objc func accountBtnHandle() {
        let accountViewController = AccountViewController(keychainManager)
        navigationController?.pushViewController(accountViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: load balance during didFinishLaunchingWithOptions
        viewModel.getBalanceAction.apply().start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
