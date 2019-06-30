//
//  TodayViewController.swift
//  ISICbalanceExtension
//
//  Created by Rostislav Babáček on 05/05/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation
import UIKit
import NotificationCenter
import SnapKit
import ReactiveSwift
import ACKReactiveExtensions
import Result

class TodayViewController: UIViewController, NCWidgetProviding {
    private weak var appButton: UIButton!
    private weak var balanceTitle: UILabel!
    private weak var balanceLabel: UILabel!
    private let viewModel: TodayViewModeling!

    // MARK: - Initialization

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModel = TodayViewModel(dependencies: AppDependency.shared)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Controller lifecycle

    override func loadView() {
        super.loadView()

        let balanceStack = UIStackView()
        balanceStack.axis = .vertical
        balanceStack.alignment = .center
        balanceStack.spacing = 5
        balanceStack.sizeToFit()
        view.addSubview(balanceStack)

        let balanceTitle = UILabel()
        // we are not able to use swiftgen, because of retain cycle
        balanceTitle.text = NSLocalizedString("balance.title", comment: "ISIC account balance")
        self.balanceTitle = balanceTitle
        balanceStack.addArrangedSubview(balanceTitle)

        let balanceLabel = UILabel()
        balanceLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.balanceLabel = balanceLabel
        balanceStack.addArrangedSubview(balanceLabel)

        balanceStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(50)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }

        let isicImage = UIImage(named: "todayExtension")
        let appButton = UIButton(type: .custom)
        appButton.setImage(isicImage, for: .normal)
        self.appButton = appButton
        view.addSubview(appButton)

        appButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(balanceStack.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(50)
            make.top.bottom.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        appButton?.addTarget(self, action: #selector(isicImageTapped), for: .touchUpInside)
        setupBindings()
    }

    // "This method is called to give a widget an opportunity to update its content and redraw its view prior to an operation such as a snapshot"
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        viewModel.actions.getBalance.apply().start()

        completionHandler(NCUpdateResult.newData)
    }

    // MARK: - Bindings

    private func setupBindings() {
        balanceLabel?.reactive.text <~ viewModel.localeBalance
        // open app is request get wrong
        viewModel.actions.getBalance.errors.observeValues { [weak self] _ in
            self?.moveToApp()
        }
        viewModel.actions.getBalance.apply().start()
    }

    // MARK: - Actions

    @objc
    private func isicImageTapped(_ sender: UIButton)) {
        moveToApp()
    }

    private func moveToApp() {
        let myAppUrl = URL(string: "ISICbalance://")!
        extensionContext?.open(myAppUrl, completionHandler: { (success) in
            if !success {
                print("❌ open app failed")
            }
        })
    }
}

extension Int {
    func asLocalCurrency() -> String {
        let currency = NSLocalizedString("balance.currency", comment: "localized balance currency")
        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = currency
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
