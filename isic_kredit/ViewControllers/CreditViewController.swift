//
//  CreditViewController.swift
//  isic_kredit
//
//  Created by Petr Dusek on 07/11/2018.
//  Copyright © 2018 Petr Dusek. All rights reserved.
//

import UIKit
import SnapKit
import JGProgressHUD

class CreditViewController: UIViewController {
    
    weak var reloadButton: UIButton!
    weak var accountButton: UIButton!
    weak var moneyLabel: UILabel!
    var hud = JGProgressHUD(style: .light)
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountButton.addTarget(self, action: #selector(accountButtonTapped(_:)), for: .touchUpInside)
        reloadButton.addTarget(self, action: #selector(reloadButtonTapped(_:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if KeyChain.standard.getUsername() == "" && KeyChain.standard.getPassword() == ""{
            let settingsController = SettingsViewController()
            navigationController?.pushViewController(settingsController, animated: true)
        } else {
            self.reloadData()
        }
        
        
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = ColorConstants.backgroundColor
        
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
        textLabel.text = NSLocalizedString("Account balance", comment: "")
        textLabel.textColor = ColorConstants.labelsColor
        textLabel.font = FontConstants.labelsFont
        
        let moneyLabel = UILabel()
        moneyLabel.text = "0 \(NSLocalizedString("CZK", comment: ""))"
        moneyLabel.textColor = .white
        moneyLabel.font = FontConstants.moneyFont
        moneyLabel.adjustsFontForContentSizeCategory = true
        self.moneyLabel = moneyLabel
    
        let mainStack = UIStackView(arrangedSubviews: [textLabel, moneyLabel, buttonsStack])
        mainStack.spacing = 30
        mainStack.distribution = .fillEqually
        mainStack.axis = .vertical
        mainStack.alignment = .center
        view.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    /*
     When account button is tapped show settings view controller
     */
    @objc func accountButtonTapped(_ sender: UIButton) {
        
        let settingsController = SettingsViewController()
        navigationController?.pushViewController(settingsController, animated: true)
    }
    
    /*
     When reload button is tapped reload data from website
     */
    @objc func reloadButtonTapped(_ sender: UIButton) {
        self.reloadData()
    }
    
    /*
     Use data manager and load money data and shows hud
     */
    func reloadData() {
        
        self.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        self.hud.textLabel.text = NSLocalizedString("Loading", comment: "")
        self.hud.show(in: self.view)
        
        dataManager.finalData(success: { response in
                                self.setMoneyValue(value: response)
                                self.hud.dismiss()
        },
                              failure: { fail in
                                self.hudError(text: fail.localizedDescription)
        })
        
    }
    
    /*
     Gets money from the site and sets it to moneyLabel.
     */
    func setMoneyValue(value: String){
        self.moneyLabel.text = "\(value) \(NSLocalizedString("CZK", comment: ""))"
    }
    
    /*
     Shows hud error with text given in parameter
     */
    func hudError(text: String){
        self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        self.hud.textLabel.text = text
        self.hud.dismiss(afterDelay: 1.0)
    }
    
}
