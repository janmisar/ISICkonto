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
import Result

class RequestManager {
    private let keychainManager: KeychainManager
    var currentBalance = MutableProperty<Balance?>(nil)

    init(_ keychainManager: KeychainManager) {
        self.keychainManager = keychainManager
    }

    func getBalance() -> SignalProducer<Balance, RequestError> {
        return getRequestsResult()
            .flatMap(.latest, { [weak self] dataResponse -> SignalProducer<Balance, RequestError> in
                guard let self = self else { return SignalProducer.init(error: RequestError.parseError) }
                return self.parseDocument(dataResponse: dataResponse)
            })
    }

    func getRequestsResult() -> SignalProducer<DataResponse<String>, RequestError> {
        return RequestManager.agataRequest().flatMap(.latest) { response -> SignalProducer<DataResponse<String>, RequestError> in
                let responseURL = response.response?.url
                let hostUrl = responseURL?.host ?? ""
                // if url contains agata.suz.cvut -> you are logged in
                if hostUrl.contains("agata.suz.cvut") {
                    return SignalProducer(value: response)
                } else {
                    let returnBase = "https://agata.suz.cvut.cz/Shibboleth.sso/Login"
//                    let returnBase = "httpuz.cvut.cz/Shibboleth.sso/Login" -> FAIL TEST
                    let filter = responseURL?.getValueOfQueryParameter("filter") ?? ""
                    let lang = responseURL?.getValueOfQueryParameter("lang") ?? ""
                    let entityID = "https://idp2.civ.cvut.cz/idp/shibboleth"
                    let returnComponents = responseURL?.getValueOfQueryParameter("return") ?? ""
                    let retunComponentsUrl = URL(string: returnComponents)

                    let samlds = retunComponentsUrl?.getValueOfQueryParameter("SAMLDS") ?? ""
                    let target = retunComponentsUrl?.getValueOfQueryParameter("target") ?? ""

                    let urlString = "\(returnBase)?SAMLDS=\(samlds)&target=\(target)&entityID=\(entityID)&filter=\(filter)&lang=\(lang)"

                    return RequestManager.ssoRequest(urlString: urlString)
                }
            }
            // TODO: Ask about line below
            .combineLatest(with: keychainManager.getCredentialsFromKeychain().promoteError(RequestError.self))
            .map { responseShibboleth, user -> (String, [String:String]) in
                //login parameters, username and password
                let parameters = [
                    "j_username": user.username,
                    "j_password": user.password,
                    "_eventId_proceed" : ""
                ]

                let credentialsUrl = responseShibboleth.response?.url?.absoluteString ?? ""
                return (credentialsUrl, parameters)
            }
            .flatMap(.latest, { (credentialsUrl, parameters) -> SignalProducer<DataResponse<String>, RequestError> in
                return RequestManager.credentialsRequest(credentialsUrl: credentialsUrl, parameters: parameters)
            })
            .flatMap(.latest, { responseCredentials -> SignalProducer<DataResponse<String>, RequestError> in
                do {
                    let document: Document = try SwiftSoup.parse(responseCredentials.result.value!)
                    #warning("TODO - check array size")
                    let form: Element = try document.select("form").array()[0]

                    //get action value from form to check login process
                    let action: String = try form.attr("action")
                    if !action.contains("agata.suz.cvut.cz"){
                        return SignalProducer.init(error: RequestError.loginFailed)
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

                    return RequestManager.balanceSiteRequest(action: action, formParameters: formParameters)
                } catch {
                    return SignalProducer.init(error: RequestError.parseError)
                }
            })
    }

    func parseDocument(dataResponse: DataResponse<String>) -> SignalProducer<Balance,RequestError> {
        return SignalProducer { [weak self] observer, _ in
            do {
                let document: Document = try SwiftSoup.parse(dataResponse.result.value!)
                #warning("TODO - check array size")
                let bodyElement: Element = try document.select("body").array()[0]
                let table: Element = try bodyElement.select("tbody").array()[0]
                let balanceLine: Element = try table.select("td").array()[4]
                let lineText = balanceLine.ownText()
                let lineElements = lineText.split(separator: " ")
                let balance = lineElements[0]
                let balanceStruct = Balance(balance: "\(balance) Kč")
                self?.currentBalance.value = balanceStruct
                // TODO: doesnt "unlock" Action"
                observer.send(value: balanceStruct)
                observer.sendCompleted()
                // TODO: solution ?
                // observer.send(error: RequestError.successfulParse)
            } catch {
                observer.send(error: RequestError.parseError)
            }
        }
    }

    // MARK: - alamofireRequests
    static func agataRequest() -> SignalProducer<DataResponse<String>,RequestError> {
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

    static func ssoRequest(urlString: String) -> SignalProducer<DataResponse<String>,RequestError> {
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

    static func credentialsRequest(credentialsUrl: String, parameters: [String : String]) -> SignalProducer<DataResponse<String>,RequestError> {
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

    static func balanceSiteRequest(action: String, formParameters: [String : String]) -> SignalProducer<DataResponse<String>,RequestError> {
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
