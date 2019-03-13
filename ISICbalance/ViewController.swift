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
                    
                    Alamofire.request(urlString).response { responseShibboleth in
                        #warning("TODO - get credentials from keychain or userdefaults")
                        let username = "xxx"
                        let password = "xxx"
                        //login parameters, username and password
                        let parameters = [
                            "j_username": username,
                            "j_password": password,
                            "_eventId_proceed" : ""
                        ]
                        
                        let credentialsUrl = responseShibboleth.response?.url?.absoluteString ?? ""
                        
                        Alamofire.request(credentialsUrl, method: .post, parameters: parameters).responseString { responseCredentials in
                            do {
                                let document: Document = try SwiftSoup.parse(responseCredentials.result.value!)
                                let form: Element = try document.select("form").array()[0]
                                
                                //get action value from form to check login process
                                let action: String = try form.attr("action")
                                if !action.contains("agata.suz.cvut.cz"){
                                    #warning("TODO - error")
                                    print("LOGIN FAILED")
                                    return
                                }
                                
                                let inputs = try form.select("input")
                                //get RelayState
                                let inputName1 = try inputs.array()[0].attr("name")
                                let inputValue1 = try inputs.array()[0].attr("value")
                                //get SAMLResponse
                                let inputName2 = try inputs.array()[1].attr("name")
                                let inputValue2 = try inputs.array()[1].attr("value")
                                
                                let formParameters = [
                                    inputName1 : inputValue1,
                                    inputName2 : inputValue2
                                ]
                                
                                Alamofire.request(action, method: .post, parameters: formParameters) .responseString { responseBalanceSite in
                                    if responseBalanceSite.result.isSuccess {
                                        self?.getBalanceFromDoc(dataResponse: responseBalanceSite)
                                        print("get balance")
                                    } else {
                                        print("error: \(responseBalanceSite.result.error)")
                                    }
                                }
                            } catch {
                                #warning("TODO - error")
                            }
                        }
                    }
                } catch {
                    #warning("TODO - error")
                }
            }
            }
        } catch {
            #warning("TODO - error")
        }
    }
    
    func getBalanceFromDoc(dataResponse: DataResponse<String>){
        do {
            let document: Document = try SwiftSoup.parse(dataResponse.result.value!)
            print(document)
        } catch {
            #warning("TODO - error")
        }
    }
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
