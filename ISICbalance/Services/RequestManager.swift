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
import ReactiveSwift

class RequestManager {
    private let keychainManager: KeychainManager
    var currentBalance = MutableProperty<Balance?>(nil)

    init(_ keychainManager: KeychainManager) {
        self.keychainManager = keychainManager
    }

    func reloadData() -> SignalProducer<Balance,RequestError> {
        return SignalProducer { observer, diposable in
            Alamofire.request("https://agata.suz.cvut.cz/secure/index.php").responseString { [weak self] response in
                guard let self = self else { return }
    
                switch response.result {
                case .success:
                    print("Agata request success")
                    self.agataRequestSucc(observer, response)
                case .failure(let error):
                    observer.send(error: RequestError.agataGetError(error: error))
                }
            }
        }
    }
    
    func agataRequestSucc(_ observer: Signal<Balance, RequestError>.Observer, _ response: (DataResponse<String>)) {
        
        let responseURL = response.response?.url
        let hostUrl = responseURL?.host ?? ""
        
        // if url contains agata.suz.cvut -> you are logged in
        if hostUrl.contains("agata.suz.cvut") {
            getBalanceFromDoc(observer, dataResponse: response)
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
            
            Alamofire.request(urlString).responseString { [weak self] responseShibboleth in
                guard let self = self else { return }
                
                switch responseShibboleth.result {
                case .success:
                    print("SSO request success")
                    self.ssoRequestSucc(observer, responseShibboleth)
                case .failure(let error):
                    observer.send(error: RequestError.ssoGetError(error: error))
                }
            }
        }
    }
    
    fileprivate func ssoRequestSucc(_ observer: Signal<Balance, RequestError>.Observer, _ responseShibboleth: (DataResponse<String>)) {
        var username: String = ""
        var password: String = ""

        keychainManager.getCredentialsFromKeychain().on(value: { [weak self] user in
            username = user.username
            password = user.password
        }).start()

        //login parameters, username and password
        let parameters = [
            "j_username": username,
            "j_password": password,
            "_eventId_proceed" : ""
        ]
        
        let credentialsUrl = responseShibboleth.response?.url?.absoluteString ?? ""
        
        Alamofire.request(credentialsUrl, method: .post, parameters: parameters).responseString { [weak self] responseCredentials in
            guard let self = self else { return }
            
            switch responseCredentials.result {
            case .success:
                print("Credentials request success")
                self.credentialsRequestSucc(observer, responseCredentials)
            case .failure(let error):
                observer.send(error: RequestError.credentialsPostError(error: error))
            }
        }
    }
    
    fileprivate func credentialsRequestSucc(_ observer: Signal<Balance, RequestError>.Observer, _ responseCredentials: (DataResponse<String>)) {
        do {
            let document: Document = try SwiftSoup.parse(responseCredentials.result.value!)
            let formArray = try document.select("form").array()
            guard formArray.count > 0 else { throw RequestError.parseError }
            let form: Element = formArray[0]
            
            //get action value from form to check login process
            let action: String = try form.attr("action")
            if !action.contains("agata.suz.cvut.cz") {
                observer.send(error: RequestError.loginFailed)
            }
            
            let inputsArray = try form.select("input").array()
            guard inputsArray.count > 1 else { throw RequestError.parseError }
            //get RelayState
            let inputName1 = try inputsArray[0].attr("name")
            let inputValue1 = try inputsArray[0].attr("value")
            //get SAMLResponse
            let inputName2 = try inputsArray[1].attr("name")
            let inputValue2 = try inputsArray[1].attr("value")
            
            let formParameters = [
                inputName1 : inputValue1,
                inputName2 : inputValue2
            ]

            Alamofire.request(action, method: .post, parameters: formParameters) .responseString { [weak self] responseBalanceSite in
                guard let self = self else { return }
                
                switch responseBalanceSite.result {
                case .success:
                    print("Balance site request success")
                    self.getBalanceFromDoc(observer, dataResponse: responseBalanceSite)
                case .failure(let error):
                   observer.send(error: RequestError.balanceScreenPostError(error: error))
                }
            }
        } catch {
            observer.send(error: RequestError.parseError)
        }
    }
    
    func getBalanceFromDoc(_ observer: Signal<Balance, RequestError>.Observer, dataResponse: DataResponse<String>) {
        do {
            let document: Document = try SwiftSoup.parse(dataResponse.result.value!)
            // get body elements
            let bodyElements = try document.select("body").array()
            guard bodyElements.count > 0 else { throw RequestError.parseError }
            let bodyElement: Element = bodyElements[0]

            // get table elements
            let tables = try bodyElement.select("tbody").array()
            guard tables.count > 0 else { throw RequestError.parseError }
            let table: Element = tables[0]

            // get balance line
            let balanceLines = try table.select("td").array()
            guard balanceLines.count > 4 else { throw RequestError.parseError }
            let balanceLine: Element = balanceLines[4]
            let lineText = balanceLine.ownText()

            // get balance
            let lineElements = lineText.split(separator: " ")
            guard lineElements.count > 0 else { throw RequestError.parseError }
            let balance = lineElements[0]

            let balanceSt = Balance(balance: "\(balance) Kč")
            self.currentBalance.value = balanceSt
            observer.send(value: balanceSt)
            observer.sendCompleted()
        } catch {
            observer.send(error: RequestError.parseError)
        }
    }
}

extension URL {
    func getValueOfQueryParameter(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
