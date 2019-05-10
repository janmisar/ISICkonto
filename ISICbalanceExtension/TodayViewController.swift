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

    override func loadView() {
        let balanceLabel = UILabel()
        balanceLabel.text = "135 CZK"
        view.addSubview(balanceLabel)

        balanceLabel.snp.makeConstraints { _ in
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
