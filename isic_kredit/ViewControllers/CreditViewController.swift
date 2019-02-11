//
//  CreditViewController.swift
//  isic_kredit
//
//  Created by Petr Dusek on 07/11/2018.
//  Copyright © 2018 Petr Dusek. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftKeychainWrapper
import SwiftSoup
import JGProgressHUD

class CreditViewController: UIViewController {
    
    weak var reloadButton: UIButton!
    weak var accountButton: UIButton!
    weak var moneyLabel: UILabel!
    var hud = JGProgressHUD(style: .light)
    
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
        
        if KeychainWrapper.standard.string(forKey: "username")==nil && KeychainWrapper.standard.string(forKey: "password")==nil{
            let settingsController = SettingsViewController()
            navigationController?.pushViewController(settingsController, animated: true)
        } else {
            self.reloadData()
        }
        
        
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = ColorConstants.BackgroundColor
        
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
        textLabel.textColor = ColorConstants.LabelsColor
        textLabel.font = FontConstants.LabelsFont
        
        let moneyLabel = UILabel()
        moneyLabel.text = "0 \(NSLocalizedString("CZK", comment: ""))"
        moneyLabel.textColor = .white
        moneyLabel.font = FontConstants.MoneyFont
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
     This function log in to https://agata.suz.cvut.cz/secure/index.php where is information about users money.
     If there is some error function shows alert.
     */
    func reloadData() {
        
        self.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        self.hud.textLabel.text = NSLocalizedString("Loading", comment: "")
        self.hud.show(in: self.view)
        
        //Request website
        Alamofire.request("https://agata.suz.cvut.cz/secure/index.php").responseString { agataResponse in
            
            //if it went good
            if let agataResponsed = agataResponse.response{
                
                //We are not logged in
                if (agataResponsed.url)!.absoluteString.contains("eduid") {
                    
                    let components = URLComponents(url: (agataResponsed.url)!, resolvingAgainstBaseURL: false)
                    
                    if let components = components {
                        
                        if let queryItemsUrl = components.queryItems {
                            let filter = queryItemsUrl[0].value! // filter component of site
                            let lang = queryItemsUrl[1].value!  // language component of site
                            let entityID = "https://idp2.civ.cvut.cz/idp/shibboleth" // entity id for cvut login
                            let insideReturnComponent = URLComponents(string: queryItemsUrl[3].value!) //inside of return component are samlds and target
                            
                            if let insideReturnComponent = insideReturnComponent {
                                let returnBase = "https://agata.suz.cvut.cz/Shibboleth.sso/Login"
                                
                                if let queryItemsReturn = insideReturnComponent.queryItems {
                                    let samlds = queryItemsReturn[0].value! // samlds component of site
                                    let target = queryItemsReturn[1].value! // target component of site
                                    
                                    let urlString = "\(returnBase)?SAMLDS=\(samlds)&target=\(target)&entityID=\(entityID)&filter=\(filter)&lang=\(lang)" //url for cvut login sso
                                    
                                    Alamofire.request(urlString).response { responseSSO in
                                        
                                        //login parameters, username and password
                                        let parameters: Parameters = [
                                            "j_username": KeychainWrapper.standard.string(forKey: "username")!,
                                            "j_password": KeychainWrapper.standard.string(forKey: "password")!,
                                            "_eventId_proceed" : ""
                                        ]
                                        
                                        Alamofire.request((responseSSO.response?.url?.absoluteString)!, method: .post, parameters: parameters) .responseString { responseJscript in
                                            
                                            do{
                                                let doc:Document = try SwiftSoup.parse(responseJscript.result.value!)
                                                let link: Element = try doc.select("form").first()!
                                                let linkAction: String = try link.attr("action")
                                                
                                                if !linkAction.contains("agata"){
                                                    self.hudError(text: NSLocalizedString("Login failed", comment: ""))
                                                    return
                                                }
                                                
                                                let inputs: Elements = try link.select("input")
                                                let input1: String = try inputs.first()!.attr("name")
                                                let input1Val: String = try inputs.first()!.attr("value")
                                                let input2: String = try inputs.array()[1].attr("name")
                                                let input2Val: String = try inputs.array()[1].attr("value")
                                                
                                                let parameters1: Parameters = [
                                                    input1 : input1Val,
                                                    input2 : input2Val
                                                ]
                                                
                                                
                                                Alamofire.request(linkAction, method: .post, parameters: parameters1) .responseString { responseFinalSite in
                                                    
                                                    if let responseFinalSite = responseFinalSite.result.value{
                                                        self.setMoneyValue(siteResultValue: responseFinalSite)
                                                        self.hudSuccess(text: NSLocalizedString("Loaded", comment: ""))
                                                    } else {
                                                        self.hudError(text: NSLocalizedString("Fail", comment: ""))
                                                        return
                                                    }
                                            
                                                }
                                                
                                            } catch{
                                                self.hudError(text: NSLocalizedString("Fail", comment: ""))
                                                return
                                            }
                                            
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                    } else {
                        self.hudError(text: NSLocalizedString("Fail", comment: ""))
                        return
                    }
                    
                  //User is logged in
                } else {
                    self.setMoneyValue(siteResultValue: (agataResponse.result.value)!)
                    self.hudSuccess(text: NSLocalizedString("Loaded", comment: ""))
                }
                //There is something wrong with the site
            } else {
                self.hudError(text: NSLocalizedString("Fail", comment: ""))
                return
                
            }
            
        }
        
    }
    
    /*
     Gets money from the site and sets it to moneyLabel.
     */
    func setMoneyValue(siteResultValue: String){
        do{
            let agataWebSite:Document = try SwiftSoup.parse(siteResultValue)
            let tbody: Element = try agataWebSite.select("tbody").first()!
            let td: Element = try tbody.select("td").array()[4]
            let arrayOfMoneyStrings = td.ownText().split(separator: ",")
            self.moneyLabel.text = "\(arrayOfMoneyStrings[0]) \(NSLocalizedString("CZK", comment: ""))"
        } catch{
        }
    }
    
    /*
     Shows hud error with text given in parameter
     */
    func hudError(text: String){
        self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        self.hud.textLabel.text = text
        self.hud.dismiss(afterDelay: 1.0)
    }
    
    /*
     Shows hud success with text given in parameter
     */
    func hudSuccess(text: String){
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.textLabel.text = text
        self.hud.dismiss(afterDelay: 1.0)
    }
    
    
}
