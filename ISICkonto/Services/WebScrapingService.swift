//
//  WebScrapingService.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 04/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import RxCocoa
import Kanna
import SwiftKeychainWrapper

// move this to bundle as constants
let agataSuzUrl: String = "https://agata.suz.cvut.cz/secure/index.php"
let sibbolethUrl: String = "https://idp2.civ.cvut.cz/idp/shibboleth"

typealias Credentials = (username: String, password: String)

enum WebScrapingService {
    case authenticate( _ requestData : Credentials)

    func request() -> Observable<Result<String>>{
        switch self {
        case .authenticate(let requestData):
            return requestSsoLogin(credentials: requestData)
        }
    }

        private func requestAgataSuz() -> Observable<Result<String>> {
            return RxAlamofire
                .requestString(.get, agataSuzUrl)
                .map { (response, html) -> Result<String> in
                    
                guard let url = response.url?.absoluteString else { return Result.resultFailed("requesting agata failed") }
                guard let responseUrl = URLComponents(string: url) else { return Result.resultFailed("creating responseUrl failed") }
                guard let hostUrl = responseUrl.host else { return Result.resultFailed("host not found") }

                if hostUrl.range(of: "agata.suz.cvut.cz") != nil {
                    return Result.resultLoggedIn(element: html)
                }

                /* if we have not got straight to agata account we have to proceed with SSO Login */
                var ssoLoginUrl = URLComponents(string: (responseUrl.queryItems?.first(where: { $0.name == "return"})!.value)!)

                /* creating url for SSO Login request */
                ssoLoginUrl?.queryItems?.append( URLQueryItem(name: "entityID", value: sibbolethUrl) )
                ssoLoginUrl?.queryItems?.append( (responseUrl.queryItems?.first(where: { $0.name == "filter" }))! )
                ssoLoginUrl?.queryItems?.append( (responseUrl.queryItems?.first(where: { $0.name == "lang" }))! )

                return Result.resultSuccess("succeeded", element: (ssoLoginUrl?.url?.absoluteString)!)
            }
        }

    private func requestSsoLogin(credentials: Credentials) -> Observable<Result<String>> {
        /* requesting agata page, checking for success and possily chaining it with SSO Login requests */

        return requestAgataSuz()
            .flatMapLatest { (agataResult) -> Observable<Result<String>> in
                
                    if agataResult.info != .success { return Observable.of(agataResult) }

                    return RxAlamofire
                        .requestString(.get, agataResult.element!)
                        .flatMapLatest { (response, _) -> Observable<Result<String>> in
                     
                            let params = ["j_username": credentials.username, "j_password": credentials.password, "_eventId_proceed": ""]

                            return RxAlamofire
                                .requestString(.post, (response.url?.absoluteString)!, parameters: params)
                                .flatMapLatest { (response2,str) -> Observable<Result<String>> in
                                    
                                    /* using Kanna to parse HTML */
                                    guard let sessionHtml = try? HTML(html: str, encoding: .utf8) else { return Observable.of(Result.resultFailed()) }

                                    /* if the resulting site contains Stale request in the title the session has expired */
                                    let staleRequest = sessionHtml.xpath("//title").first?.content
                                    if staleRequest != nil && staleRequest!.contains("Stale request") { return Observable.of(Result.resultFailed("Stale request")) }

                                    /* if the resulting page contains an error message the user has entered wrong credentials */
                                    let possibleError = sessionHtml.xpath("//p[@class='error-message']").first?.content
                                    if possibleError != nil && possibleError!.contains("Login failed.") { return Observable.of(Result.resultFailed("Wrong credentials")) }

                                    /* creating parameters and POSTing them to actionUrl to finish the SSO Login request */
                                    var parameters: [String: String] = [:]
                                    sessionHtml.xpath("//input[@type='hidden']").forEach { element in
                                        parameters[element["name"]!] = element["value"]!
                                    }
                                    if parameters.isEmpty { return Observable.of(Result.resultFailed("parameters empty")) }

                                    let actionUrl = sessionHtml.xpath("//form[@method='post']").first!["action"]

                                    return RxAlamofire
                                        .requestString(.post, actionUrl!, parameters: parameters)
                                        .map { return Result.resultLoggedIn(element: $1) }
                            }
                    }
            }
    }
}



