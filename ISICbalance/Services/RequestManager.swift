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

protocol HasRequestManager {
    var requestManager: RequestManagering { get }
}

protocol RequestManagering {
    func getBalance() -> SignalProducer<Balance, RequestError>
}

final class RequestManager: RequestManagering {
    typealias Dependencies = HasKeychainManager
    private let dependencies: Dependencies

    // MARK: - Initialization
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func getBalance() -> SignalProducer<Balance,RequestError> {
        return getBalanceSite()
            .flatMap(.latest, { response -> SignalProducer<String, RequestError> in
                // parse site with balance
                do {
                    let document: Document = try SwiftSoup.parse(response.result.value!)
                    // get body elements
                    let bodyElements = try document.select("body").array()
                    guard bodyElements.count > 0 else { throw RequestError.parseError(message: "Error - body is not included in document") }
                    let bodyElement: Element = bodyElements[0]

                    // get table elements
                    let tables = try bodyElement.select("tbody").array()
                    guard tables.count > 0 else { throw RequestError.parseError(message: "Error - tbody is not included in body") }
                    let table: Element = tables[0]

                    // get balance line
                    let balanceLines = try table.select("td").array()
                    guard balanceLines.count > 4 else { throw RequestError.parseError(message: "Error - balance line is not included in tbody") }
                    let balanceLine: Element = balanceLines[4]
                    let lineText = balanceLine.ownText()

                    // get balance
                    let lineElements = lineText.split(separator: " ")
                    guard lineElements.count > 0 else { throw RequestError.parseError(message: "Error - currency is missing") }
                    let balance = lineElements[0]

                    return SignalProducer(value: String(balance))
                } catch {
                    return SignalProducer(error: RequestError.parseError(message: "Error - parsing balance site failed"))
                }
            })
            .map { balance in
                let separatedBalance = balance.split(separator: ",")
                let stringBalance = String(separatedBalance[0])
                let intBalance = Int(stringBalance) ?? 0
                let balanceStruct = Balance(balance: intBalance)

                print("✅ parse success")
                return balanceStruct
            }
    }

    private func getBalanceSite() -> SignalProducer<DataResponse<String>, RequestError> {
        return RequestManager.agataRequest()
            .flatMap(.latest) { [weak self] response -> SignalProducer<DataResponse<String>, RequestError> in
                guard let self = self else { return SignalProducer(error: RequestError.agataGetError(message: "Error - self is nil")) }

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

                    return self.loginRequest(urlString: urlString)
                }
            }
    }

    private func loginRequest(urlString: String) -> SignalProducer<DataResponse<String>, RequestError> {
         return RequestManager.ssoRequest(urlString: urlString)
            .combineLatest(with: dependencies.keychainManager.getCredentialsFromKeychain().promoteError(RequestError.self))
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
                    let formArray = try document.select("form").array()
                    guard formArray.count > 0 else { throw RequestError.parseError(message: "Error - form does not exist") }
                    let form: Element = formArray[0]

                    //get action value from form to check login process
                    let action: String = try form.attr("action")
                    if !action.contains("agata.suz.cvut.cz") {
                        return SignalProducer(error: RequestError.loginFailed(message: "Error - login failed"))
                    }

                    let inputsArray = try form.select("input").array()
                    guard inputsArray.count > 1 else { throw RequestError.parseError(message: "Error - input does not exist") }
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

                    return RequestManager.balanceSiteRequest(action: action, formParameters: formParameters)
                } catch {
                    return SignalProducer(error: RequestError.parseError(message: "Error - parsing login site failed"))
                }
            })
    }

    // MARK: - Alamofire requests
    private static func agataRequest() -> SignalProducer<DataResponse<String>,RequestError> {
        return SignalProducer { observer, _ in
            Alamofire.request("https://agata.suz.cvut.cz/secure/index.php").responseString { response in
                switch response.result {
                case .success:
                    observer.send(value: response)
                    observer.sendCompleted()
                case .failure:
                    observer.send(error: RequestError.agataGetError(message: "Error - agata get request failed"))
                }
            }
        }
    }

    private static func ssoRequest(urlString: String) -> SignalProducer<DataResponse<String>,RequestError> {
        return SignalProducer { observer, _ in
            Alamofire.request(urlString).responseString { responseShibboleth in
                switch responseShibboleth.result {
                case .success:
                    observer.send(value: responseShibboleth)
                    observer.sendCompleted()
                case .failure:
                    observer.send(error: RequestError.ssoGetError(message: "Error - sso get request failed"))
                }
            }
        }
    }

    private static func credentialsRequest(credentialsUrl: String, parameters: [String : String]) -> SignalProducer<DataResponse<String>,RequestError> {
        return SignalProducer { observer, _ in
            Alamofire.request(credentialsUrl, method: .post, parameters: parameters).responseString { responseCredentials in
                switch responseCredentials.result {
                case .success:
                    observer.send(value: responseCredentials)
                    observer.sendCompleted()
                case .failure:
                    observer.send(error: RequestError.credentialsPostError(message: "Error - credencial post request failed"))
                }
            }
        }
    }

    private static func balanceSiteRequest(action: String, formParameters: [String : String]) -> SignalProducer<DataResponse<String>,RequestError> {
        return SignalProducer { observer, _ in
            Alamofire.request(action, method: .post, parameters: formParameters) .responseString { responseBalanceSite in
                switch responseBalanceSite.result {
                case .success:
                    observer.send(value: responseBalanceSite)
                    observer.sendCompleted()
                case .failure:
                     observer.send(error: RequestError.balanceScreenPostError(message: "Error - move to balance site request failed"))
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
