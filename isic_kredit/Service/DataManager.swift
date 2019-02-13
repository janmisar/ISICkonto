//
//  DataManager.swift
//  isic_kredit
//
//  Created by Petr Dusek on 12/02/2019.
//  Copyright © 2019 Petr Dusek. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup


class DataManager {
    
    /*
     Tries to get response from site agata.suz.cvut.cz notLogged when you are not logged in, logged when response site is agata.suz.. and fail if there is some error
     */
    private func getAgataResponse(notLogged: @escaping (URL) -> Void , logged: @escaping (String) -> Void, failure: @escaping (Error) -> Void){

        Alamofire.request("https://agata.suz.cvut.cz/secure/index.php").responseString { response in

            //if there is some error return in failure
            if let error = response.error{
                failure(error)
            } else {
                if let responsed = response.response{ //get response
                    //get url
                    if let url = responsed.url {
                        
                        //if url contains eduid it means we are not logged in, eduid is site where you choosing login options as cvut and vscht sso
                        if url.absoluteString.contains("eduid"){
                            notLogged(url)
                        } else {
                            if let value = response.result.value{
                                logged(value)
                            }
                            
                        }
                    }
                }
            }
        
        }
        
    }
    
    /*
     Gets components from responded url: agata.suz.cvut.cz when you are not logged in and returns (Bool, String), bool if it was succesfull or not and string which is the url needed for redirecting to cvut sso login
     */
    private func getComponents(url: URL) -> (Bool, String){
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
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
                        
                        return (true, urlString)
                    }
                }
            }
        }
        
        return (false, "")
    }
    
    /*
     Gets sso site just alamofire request
     */
    private func getSsoSite(url: String, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        Alamofire.request(url).response { response in
            
            if let error = response.error{
                failure(error)
            } else {
                if let response = response.response {
                    if let url = response.url {

                        success(url.absoluteString)
                        
                    }
                }
            }
            
        }
    }
    
    /*
     Posts parameters to url given as string
     */
     private func postToURL(url: String, parameters: Parameters, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void){

        Alamofire.request(url, method: .post, parameters: parameters) .responseString { response in
            if let error = response.error {
                    failure(error)
            } else {
                if let responseValue = response.result.value{
                        success(responseValue)
                    
                }
            }
            
        }
    
    }
    
    
    /*
     Gets parameters and link from Javascript url, because you must push button on site
     */
    private func getJScript(value: String) -> (Bool, Parameters, String){
        
        do{
            let doc:Document = try SwiftSoup.parse(value)
            let link: Elements = try doc.select("form")
            
            if let link = link.first(){
                let linkAction: String = try link.attr("action")
                
                if !linkAction.contains("agata"){
                    return (false, [:], "")
                }
                
                let inputs: Elements = try link.select("input")
                let input1: String = try inputs.first()!.attr("name")
                let input1Val: String = try inputs.first()!.attr("value")
                let input2: String = try inputs.array()[1].attr("name")
                let input2Val: String = try inputs.array()[1].attr("value")
                
                let parameters: Parameters = [
                    input1 : input1Val,
                    input2 : input2Val
                ]
                
                return (true, parameters,linkAction)
            }

            return (false, [:],"")
            
        } catch {
            return (false, [:],"")
        }
    }
    
    /*
     Gets money value from the final site it is in 4th element in tbody
     function returns (Bool, String), bool if it was succesfull and string is money value
    */
    private func getMoneyValue(siteValue: String) -> (Bool, String){
        do{
            let agataWebSite:Document = try SwiftSoup.parse(siteValue)
            let tbody: Elements = try agataWebSite.select("tbody")
            if let tbody = tbody.first(){
                let td: Elements = try tbody.select("td")
            
                let arrayOfMoneyStrings = td.array()[4].ownText().split(separator: ",")
                
                return (true, String(arrayOfMoneyStrings[0]))
            }
           return (false, "")
        } catch{
            return (false, "")
        }
    }
    
    /*
     Uses other functions and has success and failurre, in success should be money value at the end, in failure is Error with message
    */
    func finalData(success: @escaping (String) -> Void , failure: @escaping (Error) -> Void){
        //login parameters
        let parameters: Parameters = [
            "j_username": KeyChain().getUsername(),
            "j_password": KeyChain().getPassword(),
            "_eventId_proceed" : ""
        ]
        
        //get response for agata site
        self.getAgataResponse(
            //when you are not logged in
            notLogged: { response in
                //you need to get components of responsed site
                let componentRespond = self.getComponents(url: response)
                //when getComponents function was successful
                if componentRespond.0 {
                    //get sso site from componentRespond, in .1 is string of site
                    self.getSsoSite(url: componentRespond.1,
                                    success: { ssoResponse in //successful function
                                        self.postToURL(url: ssoResponse, parameters: parameters, //posts login data to sso form
                                                       success: { loginResponse in //post was successful
                                                        let javaScript = self.getJScript(value: loginResponse) //gets javascript site components
                                                        if javaScript.0 { //if javascript site was successful
                                                            self.postToURL(url: javaScript.2, parameters: javaScript.1, //click button on jscript site
                                                                           success: { finalSite in //when successful get money from site
                                                                                let value = self.getMoneyValue(siteValue: finalSite)
                                                                            
                                                                            if value.0 {
                                                                                success(value.1)
                                                                            } else { //cant get money from site
                                                                                failure(FailError.customError)
                                                                            }
                                                                            
                                                            },
                                                                           failure: { postFail in
                                                                            failure(postFail)
                                                            })
                                                        } else { //javascript site failed, bad password or username
                                                            failure(LoginError.customError)
                                                        }
                                        },             //post wasnt successful
                                                       failure: { loginFail in
                                                        failure(loginFail)
                    
                                        })
                    },              //get sso site wasnt successful
                                    failure: { ssoFail in
                                        failure(ssoFail)
                    })
                //when getComponents function wasnt successful
                } else {
                    failure(FailError.customError)
                }
            
        },  //when you are logged just get money valu from the final site
            logged: { site in
                success(self.getMoneyValue(siteValue: site).1)
        },
            //failure when there is errorxs
            failure: { fail in
              failure(fail)
        })

    }
    
    
}
