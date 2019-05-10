//
//  TodayViewController.swift
//  ISICbalanceExtension
//
//  Created by Rostislav Babáček on 05/05/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit
import NotificationCenter
import SnapKit

class TodayViewController: UIViewController, NCWidgetProviding {

    weak var isicImageView: UIButton?

    override func loadView() {
        super.loadView()

        let balanceStack = UIStackView()
        balanceStack.axis = .vertical
        balanceStack.spacing = 5
        balanceStack.sizeToFit()
        view.addSubview(balanceStack)

        let balanceTitle = UILabel()
        balanceTitle.text = "Na účtu máte:"
        balanceStack.addArrangedSubview(balanceTitle)

        let balanceLabel = UILabel()
        balanceLabel.text = "135 CZK"
        balanceLabel.font = UIFont.boldSystemFont(ofSize: 26)
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

    }

    @objc func isicImageTapped() {
        let myAppUrl = URL(string: "ISICbalance://")!
        extensionContext?.open(myAppUrl, completionHandler: { (success) in
            if !success {
                // let the user know it failed
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
