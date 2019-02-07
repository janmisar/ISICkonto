//
//  ViewController.swift
//  isic_kredit
//
//  Created by Petr Dusek on 07/11/2018.
//  Copyright © 2018 Petr Dusek. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class CreditViewController: UIViewController {
    
    weak var reloadButton: UIButton!
    weak var accountButton: UIButton!
    weak var moneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let UDVC = SettingsViewController()
        present(UDVC, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(red:0.27, green:0.60, blue:0.72, alpha:1.0)
        
        let reloadButton = UIButton()
        reloadButton.setImage(UIImage(named: "reloadIcon"), for: .normal)
        
        self.reloadButton = reloadButton
        
        
        let accountButton = UIButton()
        accountButton.setImage(UIImage(named: "accountIcon"), for: .normal)
        
        self.accountButton = accountButton
        
        let buttonsStack = UIStackView(arrangedSubviews: [reloadButton, accountButton])
        buttonsStack.spacing = 30
        buttonsStack.distribution = .fillEqually
        
        let textLabel = UILabel()
        textLabel.text = "Na účtu máte"
        textLabel.textColor = UIColor(red:0.70, green:0.83, blue:0.94, alpha:1.0)
        textLabel.font = UIFont(name: "System", size: 17)
        
        let moneyLabel = UILabel()
        moneyLabel.text = "0 Kč"
        moneyLabel.textColor = .white
        moneyLabel.font = UIFont(name: "Helvetica Neue", size: 80)
        self.moneyLabel = moneyLabel
        
        let mainStack = UIStackView(arrangedSubviews: [textLabel, moneyLabel, buttonsStack])
        mainStack.spacing = 30
        mainStack.distribution = .fillEqually
        mainStack.axis = .vertical
        mainStack.alignment = .center
        view.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
        

}
