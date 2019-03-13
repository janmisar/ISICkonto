//
//  ViewController.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 10/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftSoup

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        reloadData()
    }
    
    func reloadData() {
        
 
        do {
            Alamofire.request("https://agata.suz.cvut.cz/secure/index.php").response { [weak self] response in
            
            let responseURL = response.response?.url
            let hostUrl = responseURL?.host ?? ""
            
            // if url contains agata.suz.cvut -> you are logged in
            if hostUrl.contains("agata.suz.cvut") {
                //readBalanceFromDocument
            } else {
                
                do {
                    let returnBase = "https://agata.suz.cvut.cz/Shibboleth.sso/Login"
                    
                    let filter = responseURL?.valueOf("filter") ?? ""
                    let lang = responseURL?.valueOf("lang") ?? ""
                    let entityID = "https://idp2.civ.cvut.cz/idp/shibboleth"
                    let returnComponents = responseURL?.valueOf("return") ?? ""
                    let returnComponentsUrl = try (returnComponents.asURL())
                    
                    let samlds = returnComponentsUrl.valueOf("SAMLDS") ?? ""
                    let target = returnComponentsUrl.valueOf("target") ?? ""
                    
                    let urlString = "\(returnBase)?SAMLDS=\(samlds)&target=\(target)&entityID=\(entityID)&filter=\(filter)&lang=\(lang)"
                    
                    print(urlString)
                } catch {
                    
                }
            }
            }
            
        } catch {
                
        }
    }
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
