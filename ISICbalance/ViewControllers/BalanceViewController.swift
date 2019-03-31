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
    private let viewModel: BalanceViewModel
    
    private weak var screenStackView: UIStackView!
    private weak var balanceLabel: UILabel!
    private weak var balanceTitle: UILabel!
    private weak var reloadButton: UIButton!
    private weak var accountButton: UIButton!

    // MARK: - Initialization
    override init() {
        // TODO: nedostatečný DI
        self.viewModel = BalanceViewModel(dependencies: AppDependency.shared)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Controller lifecycle
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.Theme.backgroundColor
        
        let screenStackView = UIStackView()
        screenStackView.axis = .vertical
        screenStackView.spacing = 60
        self.screenStackView = screenStackView
        self.view.addSubview(screenStackView)
        
        screenStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview() // TODO: zbytečný centerX
            make.leading.trailing.equalToSuperview().inset(50)
            make.top.greaterThanOrEqualTo(30)
            make.bottom.lessThanOrEqualTo(-30)
        }
        
        setupBalanceField()
        setupButtonsStack()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // TODO: fuck self
        self.accountButton.addTarget(self, action: #selector(accountBtnHandle), for: .touchUpInside)
        self.reloadButton.addTarget(self, action: #selector(reloadBalance), for: .touchUpInside)
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: load balance during didFinishLaunchingWithOptions
        viewModel.actions.getBalanceAction.apply().start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - UI setup
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

    // MARK: - Bindings
    func setupBindings() {
        self.balanceLabel.reactive.text <~ viewModel.balance
        // push accountViewController if there is some error duting balanceAction 
        viewModel.getBalanceAction.errors.producer.startWithValues { [weak self] error in
            guard case RequestError.successfulParse = error else {
                // TODO: nevolat handle odjinud než z buttonu
                self?.accountBtnHandle()
                return
            }
        }
    }

    // MARK: - Actions
    @objc func reloadBalance() {
        // TODO: delete after dev
        print("RELOAD BALANCE HANDLE")
        viewModel.actions.getBalanceAction.apply().start()
    }
    
    @objc func accountBtnHandle() {
        let accountViewController = AccountViewController()
        navigationController?.pushViewController(accountViewController, animated: true)
    }
}
