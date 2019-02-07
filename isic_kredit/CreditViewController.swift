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
        
//        Alamofire.request("https://www.britishairways.com/travel/viewaccount/execclub/_gf/en_gb?eId=549102&source=HDEXC2").responseJSON { response in
//            print("\(response.result.value)") // http url response result
//        }
        
//        Alamofire.request("https://idp2.civ.cvut.cz/idp/profile/SAML2/Redirect/SSO?execution=e1s1", method: .post, parameters: parameters)
//            .responseData { response in
//                guard let data = response.data, response.error == nil else {
//                    print(response.error?.localizedDescription ?? "Unknown error")
//                    return
//                }
//
//
//        // Note that you will want to use a `NSMutableURLRequest`
//        // because otherwise, you will not be able to edit the `request.HTTPMethod`
//
//    }
        var string = "https%3A%2F%2Fagata.suz.cvut.cz%2FShibboleth.sso%2FLogin%3FSAMLDS%3D1%26target%3Dss%253Amem%253A7bef0c7b5903e4ef91ffd614e2fb1d87b95eb7e18eafb21b3948567a943dff0d"
        var entityId = "https://idp2.civ.cvut.cz/idp/shibboleth"
        
        var h = "https://agata.suz.cvut.cz/Shibboleth.sso/Login?SAMLDS=1&target=ss%3Amem%3A9643771f9a20ad24c4c47467b5c1680771d915e7655183e585bd72e3718f6fb5&entityID=https://idp2.civ.cvut.cz/idp/shibboleth&filter=eyJhbGxvd0ZlZWRzIjogWyJlZHVJRC5jeiJdLCAiYWxsb3dJZFBzIjogWyJodHRwczovL3dzc28udnNjaHQuY3ovaWRwL3NoaWJib2xldGgiLCJodHRwczovL2lkcDIuY2l2LmN2dXQuY3ovaWRwL3NoaWJib2xldGgiXSwgImFsbG93SG9zdGVsIjogZmFsc2UsICJhbGxvd0hvc3RlbFJlZyI6IGZhbHNlfQ%3D%3D&lang=cz"
        
//        Alamofire.request("https://agata.suz.cvut.cz/secure/index.php")
//            .response { response in
//                if let r = response.response {
//                    if let url = r.url {
//                        print(url.standardized)
////                        print(url.query)
////                        print(r)
//
//
//
//
//                    }
//                }
////                print("\(response.response)")
//                }
        let parameters: Parameters = [
            "j_username": "dusekpe2",
            "j_password": "p2F51i6TcVUT79785D2018"
        ]
        
        Alamofire.request(h) .response { response in
            print(response.response)
            print("========================================")
            Alamofire.request("https://idp2.civ.cvut.cz/idp/profile/SAML2/Redirect/SSO?execution=e1s1", method: .post, parameters: parameters) .response {
                odpoved in
                print(odpoved.response)
                
            }
            
        }
        
    }
        

}
