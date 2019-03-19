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

    func getBalance() -> SignalProducer<DataResponse<String>,RequestError> {
        return RequestManager.reloadData().flatMap(.latest) { response -> SignalProducer<DataResponse<String>, RequestError> in
                let responseURL = response.response?.url
                let hostUrl = responseURL?.host ?? ""

                // if url contains agata.suz.cvut -> you are logged in
                if hostUrl.contains("agata.suz.cvut") {
                    print("YOU ARE IN")
                    return self.parseDocument(dataResponse: response)
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

                    return RequestManager.agataRequestSucc(urlString: urlString)
                }
            }
            .map { responseShibboleth -> (String, [String:String]) in
                var username: String = ""
                var password: String = ""

                self.keychainManager.getCredentialsFromKeychain().on(value: { [weak self] user in
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
                return (credentialsUrl, parameters)
            }
            .flatMap(.latest, { (credentialsUrl, parameters) -> SignalProducer<DataResponse<String>, RequestError> in
                return RequestManager.ssoRequestSucc(credentialsUrl: credentialsUrl, parameters: parameters)
            })
            .flatMap(.latest, { [weak self] responseCredentials -> SignalProducer<DataResponse<String>, RequestError> in
                do {
                    let document: Document = try SwiftSoup.parse(responseCredentials.result.value!)
                    #warning("TODO - check array size")
                    let form: Element = try document.select("form").array()[0]

                    //get action value from form to check login process
                    let action: String = try form.attr("action")
                    if !action.contains("agata.suz.cvut.cz"){
                        return SignalProducer { observer, _ in
                            observer.send(error: RequestError.loginFailed)
                        }
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

                    return RequestManager.credentialsRequestSucc(action: action, formParameters: formParameters)
                } catch {
                    return SignalProducer { observer, _ in
                        observer.send(error: RequestError.parseError)
                    }
                }
            })
            .flatMap(.latest, { dataResponse -> SignalProducer<DataResponse<String>, RequestError> in
                return self.parseDocument(dataResponse: dataResponse)
            })


    }

    func parseDocument(dataResponse: DataResponse<String>) -> SignalProducer<DataResponse<String>,RequestError> {
        return SignalProducer { [weak self] observer, _ in
            guard let self = self else { return }

            do {
                let document: Document = try SwiftSoup.parse(dataResponse.result.value!)
                #warning("TODO - check array size")
                let bodyElement: Element = try document.select("body").array()[0]
                let table: Element = try bodyElement.select("tbody").array()[0]
                let balanceLine: Element = try table.select("td").array()[4]
                let lineText = balanceLine.ownText()
                let lineElements = lineText.split(separator: " ")
                let balance = lineElements[0]
                let user = Balance(balance: "\(balance) Kč")
                self.currentBalance.value = user
                observer.sendCompleted()
            } catch {
                observer.send(error: RequestError.parseError)
            }
        }
    }

    static func reloadData() -> SignalProducer<DataResponse<String>,RequestError> {
        return SignalProducer { observer, _ in
            Alamofire.request("https://agata.suz.cvut.cz/secure/index.php").responseString { response in

                switch response.result {
                case .success:
                    print("Agata request success")
                    observer.send(value: response)
                case .failure(let error):
                    observer.send(error: RequestError.agataGetError(error: error))
                }
            }
        }
    }

    static func agataRequestSucc(urlString: String) -> SignalProducer<DataResponse<String>,RequestError> {
        return SignalProducer { observer, _ in
            Alamofire.request(urlString).responseString { responseShibboleth in

                switch responseShibboleth.result {
                case .success:
                    print("SSO request success")
                    observer.send(value: responseShibboleth)
                case .failure(let error):
                    observer.send(error: RequestError.ssoGetError(error: error))
                }
            }
        }
    }

    static func ssoRequestSucc(credentialsUrl: String, parameters: [String : String]) -> SignalProducer<DataResponse<String>,RequestError> {
        return SignalProducer { observer, _ in
            Alamofire.request(credentialsUrl, method: .post, parameters: parameters).responseString { responseCredentials in

                switch responseCredentials.result {
                case .success:
                    print("Credentials request success")
                    observer.send(value: responseCredentials)
                case .failure(let error):
                    observer.send(error: RequestError.credentialsPostError(error: error))
                }
            }
        }
    }

    static func credentialsRequestSucc(action: String, formParameters: [String : String]) -> SignalProducer<DataResponse<String>,RequestError> {
        return SignalProducer { observer, _ in
            Alamofire.request(action, method: .post, parameters: formParameters) .responseString { responseBalanceSite in

                switch responseBalanceSite.result {
                case .success:
                    print("Balance site request success")
                    observer.send(value: responseBalanceSite)
                case .failure(let error):
                    observer.send(error: RequestError.balanceScreenPostError(error: error))
                }
            }
        }
    }
}

extension URL {
    func getValueOfQueryParameter(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
