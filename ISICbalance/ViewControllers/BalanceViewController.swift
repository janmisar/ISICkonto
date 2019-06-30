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
import SVProgressHUD

protocol BalanceFlowDelegate: class {
    func balanceRequestError(in viewController: BalanceViewController)
    func accountButtonTapped(in viewController: BalanceViewController)
}

class BalanceViewController: BaseViewController {
    private let viewModel: BalanceViewModeling
    
    private weak var screenStackView: UIStackView!
    private weak var balanceLabel: UILabel!
    private weak var balanceTitle: UILabel!
    private weak var reloadButton: UIButton!
    private weak var accountButton: UIButton!
    private weak var refreshControll: UIRefreshControl!

    weak var flowDelegate: BalanceFlowDelegate?

    // MARK: - Initialization
    init(viewModel: BalanceViewModeling) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Controller lifecycle
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.theme.backgroundColor
        
        let screenStackView = UIStackView()
        screenStackView.axis = .vertical
        screenStackView.alignment = .center
        screenStackView.spacing = 60
        self.screenStackView = screenStackView
        self.view.addSubview(screenStackView)
        
        screenStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(30)
            make.bottom.lessThanOrEqualTo(-30)
        }
        
        setupBalanceField()
        setupButtonsStack()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        accountButton.addTarget(self, action: #selector(accountBtnHandle), for: .touchUpInside)
        reloadButton.addTarget(self, action: #selector(reloadBtnHandle), for: .touchUpInside)
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadBalance()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - UI setup
    private func setupBalanceField() {
        let balanceTitle = UILabel()
        balanceTitle.text = L10n.Balance.title
        balanceTitle.textColor = UIColor.theme.labelBlue
        balanceTitle.textAlignment = .center
        balanceTitle.font = UIFont.systemFont(ofSize: 18)
        self.balanceTitle = balanceTitle
        screenStackView.addArrangedSubview(balanceTitle)

        let balanceLabel = UILabel()
        balanceLabel.textColor = UIColor.theme.textColor
        balanceLabel.adjustsFontSizeToFitWidth = true
        balanceLabel.textAlignment = .center
        balanceLabel.font = UIFont.boldSystemFont(ofSize: 80)
        self.balanceLabel = balanceLabel
        screenStackView.addArrangedSubview(balanceLabel)
    }
    
    private func setupButtonsStack() {
        let reloadButton = UIButton()
        reloadButton.setImage(Asset.reloadIcon.image, for: .normal)
        self.reloadButton = reloadButton

        let accountButton = UIButton()
        accountButton.setImage(Asset.accountIcon.image, for: .normal)
        accountButton.isUserInteractionEnabled = true
        self.accountButton = accountButton

        let buttonsStackView = UIStackView(arrangedSubviews: [reloadButton, UIView(), accountButton])
        buttonsStackView.distribution = .fillEqually
        screenStackView.addArrangedSubview(buttonsStackView)
    }

    // MARK: - Bindings
    private func setupBindings() {
        balanceLabel.reactive.text <~ viewModel.localeBalance
        // push accountViewController if there is some error duting balanceAction
        viewModel.actions.getBalance.errors
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                guard let self = self else { return }
                SVProgressHUD.showError(withStatus: L10n.Balance.credentialsError)
                SVProgressHUD.dismiss(withDelay: 1)
                self.flowDelegate?.balanceRequestError(in: self)
            }

        viewModel.actions.getBalance.completed
            .observe(on: UIScheduler())
            .observeValues {
                SVProgressHUD.dismiss(withDelay: 1)
            }
    }

    // MARK: - Actions
    private func reloadBalance() {
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: L10n.Balance.loading)
        }
        viewModel.actions.getBalance.apply().start()
    }

    @objc
    private func reloadBtnHandle(_ sender: UIButton) {
        reloadBalance()
    }
    
    @objc
    private func accountBtnHandle(_ sender: UIButton) {
        flowDelegate?.accountButtonTapped(in: self)
    }
}
