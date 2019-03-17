//
//  RequestManager.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 14/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup
import SwiftKeychainWrapper

class RequestManager {
    
    func reloadData() throws {
        Alamofire.request("https://agata.suz.cvut.cz/secure/index.php").responseString { response in
            
            switch response.result {
            case .success:
                print("Agata request success")
                self.agataRequestSucc(response)
            case .failure(let error):
                return (self.handleError(error: RequestError.agataGetError(error: error)))
            }
        }
    }
    
    func agataRequestSucc(_ response: (DataResponse<String>)) {
        
        let responseURL = response.response?.url
        let hostUrl = responseURL?.host ?? ""
        
        // if url contains agata.suz.cvut -> you are logged in
        if hostUrl.contains("agata.suz.cvut") {
            print("YOU ARE IN")
            getBalanceFromDoc(dataResponse: response)
        } else {
            let returnBase = "https://agata.suz.cvut.cz/Shibboleth.sso/Login"
            
            let filter = responseURL?.getValueOfQueryParameter("filter") ?? ""
            let lang = responseURL?.getValueOfQueryParameter("lang") ?? ""
            let entityID = "https://idp2.civ.cvut.cz/idp/shibboleth"
            let returnComponents = responseURL?.getValueOfQueryParameter("return") ?? ""
            let retunComponentsUrl = URL(string: returnComponents)
            
            let samlds = retunComponentsUrl?.getValueOfQueryParameter("SAMLDS") ?? ""
            let target = retunComponentsUrl?.getValueOfQueryParameter("target") ?? ""
            
            let urlString = "\(returnBase)?SAMLDS=\(samlds)&target=\(target)&entityID=\(entityID)&filter=\(filter)&lang=\(lang)"
            
            Alamofire.request(urlString).responseString { responseShibboleth in
                
                switch responseShibboleth.result {
                case .success:
                    print("SSO request success")
                    self.ssoRequestSucc(responseShibboleth)
                case .failure(let error):
                    return self.handleError(error: RequestError.ssoGetError(error: error))
                }
            }
        }
    }
    
    fileprivate func ssoRequestSucc(_ responseShibboleth: (DataResponse<String>)) {
        #warning("TODO- create keychain manager")
        guard let username = KeychainWrapper.standard.string(forKey: "username") else {
            #warning("TODO - show AccountVC")
            return
        }
        
        guard let password = KeychainWrapper.standard.string(forKey: "password") else {
            #warning("TODO - show AccountVC")
            return
        }
        //login parameters, username and password
        let parameters = [
            "j_username": username,
            "j_password": password,
            "_eventId_proceed" : ""
        ]
        
        let credentialsUrl = responseShibboleth.response?.url?.absoluteString ?? ""
        
        Alamofire.request(credentialsUrl, method: .post, parameters: parameters).responseString { responseCredentials in
            
            switch responseCredentials.result {
            case .success:
                print("Credentials request success")
                self.credentialsRequestSucc(responseCredentials)
            case .failure(let error):
                return self.handleError(error: RequestError.credentialsPostError(error: error))
            }
        }
    }
    
    fileprivate func credentialsRequestSucc(_ responseCredentials: (DataResponse<String>)) {
        do {
            let document: Document = try SwiftSoup.parse(responseCredentials.result.value!)
            #warning("TODO - check array size")
            let form: Element = try document.select("form").array()[0]
            
            //get action value from form to check login process
            let action: String = try form.attr("action")
            if !action.contains("agata.suz.cvut.cz"){
                return handleLoginError(error: LoginError.loginFailed)
            }
            
            let inputs = try form.select("input")
            //get RelayState
            #warning("TODO - check array size")
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
                
                switch responseBalanceSite.result {
                case .success:
                    print("Credentials request success")
                    self.getBalanceFromDoc(dataResponse: responseBalanceSite)
                case .failure(let error):
                    return self.handleError(error: RequestError.balanceScreenPostError(error: error))
                }
            }
        } catch {
            
        }
    }
    
    func getBalanceFromDoc(dataResponse: DataResponse<String>){
        do {
            let document: Document = try SwiftSoup.parse(dataResponse.result.value!)
            #warning("TODO - check array size")
            let bodyElement: Element = try document.select("body").array()[0]
            let table: Element = try bodyElement.select("tbody").array()[0]
            let balanceLine: Element = try table.select("td").array()[4]
            let lineText = balanceLine.ownText()
            let lineElements = lineText.split(separator: " ")
            let balance = lineElements[0]
            
            print("-----------------------------------------")
            print(balance)
        } catch {
            #warning("TODO - error")
        }
    }
    
    func handleError(error: RequestError) {
        print(error)
        #warning("TODO - error action")
    }
    
    func handleLoginError(error: LoginError) {
        print(error)
        #warning("TODO - error action")
    }
    
    func handleSwiftSoupError(error: SwiftSoupError) {
        print(error)
        #warning("TODO - error action")
    }
}

extension URL {
    func getValueOfQueryParameter(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
