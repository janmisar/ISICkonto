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

class TodayViewController: UIViewController, NCWidgetProviding {

    weak var isicImageView: UIButton?
    weak var balanceTitle: UILabel?
    weak var balanceLabel: UILabel?

    override func loadView() {
        super.loadView()

        let balanceStack = UIStackView()
        balanceStack.axis = .vertical
        balanceStack.spacing = 5
        balanceStack.sizeToFit()
        view.addSubview(balanceStack)

        let balanceTitle = UILabel()
        self.balanceTitle = balanceTitle
        balanceStack.addArrangedSubview(balanceTitle)

        let balanceLabel = UILabel()
        balanceLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.balanceLabel = balanceLabel
        balanceStack.addArrangedSubview(balanceLabel)

        balanceStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(50)
            make.centerY.equalToSuperview()
        }

        let isicImage = UIImage(named: "todayExtension")
        let isicImageView = UIButton(type: .custom)
        isicImageView.setImage(isicImage, for: .normal)
        self.isicImageView = isicImageView
        view.addSubview(isicImageView)

        isicImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(50)
            make.centerY.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        isicImageView?.addTarget(self, action: #selector(isicImageTapped), for: .touchUpInside)
        setupData()
    }

    func setupData() {
        if let userDefaults = UserDefaults(suiteName: "group.eu.cz.babacros.ISICbalance") {
            let currency = userDefaults.string(forKey: "currency") ?? "Kč"
            let balance = userDefaults.string(forKey: "balance") ?? "0"
            let title = userDefaults.string(forKey: "balanceTitle") ?? "Na účtu máte"

            balanceLabel?.text = Int(balance)?.asLocalCurrency(currency: currency)
            balanceTitle?.text = title
        }
    }

    @objc func isicImageTapped() {
        let myAppUrl = URL(string: "ISICbalance://")!
        extensionContext?.open(myAppUrl, completionHandler: { (success) in
            if !success {
                print("❌ open app failed")
            }
        })
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)

    }
    
}

extension Int {
    func asLocalCurrency(currency: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = currency
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
