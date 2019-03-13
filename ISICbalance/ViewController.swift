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
    
    let username = "xxx"
    let password = "xxx"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        reloadData()
    }
    
    func reloadData() {
        
        Alamofire.request("https://agata.suz.cvut.cz/secure/index.php").response { [weak self] response in
            
            let responseURL = response.response?.url
            let hostUrl = responseURL?.host ?? ""
            
            // if url contains agata.suz.cvut -> you are logged in
            if hostUrl.contains("agata.suz.cvut") {
                //readBalanceFromDocument
            } else {
                let queryParams = self?.parseQueryString(queryString: responseURL?.query ?? "")
                let dirtyReturnObject = queryParams?["return"] as? String
                let returnObject = dirtyReturnObject?.removingPercentEncoding ?? ""
                let returnURL = URL(string: returnObject)
                let returnQuery = returnURL?.query
                
                // setup returnBase from returnUrl
                let returnBase = NSURLComponents()
                returnBase.scheme = returnURL?.scheme
                returnBase.host = returnURL?.host
                returnBase.path = returnURL?.path
                let returnBaseUrlString = returnBase.url?.absoluteString ?? ""
                
                // parse next level of query to get filter and lang
                let queryReturnObject = self?.parseQueryString(queryString: returnQuery ?? "")
                queryParams?["return"] = queryReturnObject
                
                let samlds = queryReturnObject?["SAMLDS"] as? String ?? ""
                let target = queryReturnObject?["target"] as? String ?? ""
                let entityID = "https://idp2.civ.cvut.cz/idp/shibboleth"
                let filter = queryParams?["filter"] as? String ?? ""
                //let filter = dirtyFilter?.replacingOccurrences(of: "=", with: "%3D") ?? ""
                let lang = queryParams?["lang"] as? String ?? ""
                
                let urlString = String(format: "%@?SAMLDS=%@&target=%@&entityID=%@&filter=%@&lang=%@", returnBase,samlds,target,entityID,filter,lang)
                
                print("\(returnBase)\n\(samlds)\n\(target)\n\(entityID)\n\(filter)\n\(lang)")
                
                Alamofire.request(urlString).response { [weak self] responseR in
                    
                    let parameters: Parameters = [
                        "j_username": self?.username,
                        "j_password": self?.password,
                        "_eventId_proceed" : ""
                    ]
                    
                    let url = responseR.request?.url?.absoluteString ?? ""
                    print(url)
                    
                    // post with credentials
                    Alamofire.request(url, method: .post, parameters: parameters).responseString { [weak self] response in
                        
                        //
                        do{
                            let doc: Document = try SwiftSoup.parse(response.result.value!)
                            let link: Element = try doc.select("form").first()!
                            let linkAction: String = try link.attr("action")
                          
                        } catch {}
                    }
                }
            }
        }
    }
    
    // query parsing, parsing from string to dictionary
    func parseQueryString(queryString: String) -> NSMutableDictionary {
        let queryStringDictionary = NSMutableDictionary()
        let urlComponents = queryString.components(separatedBy: "&")
        
        for keyValuePair in urlComponents {
            if let equalSignIndex = keyValuePair.firstIndex(of: "=") {
                let key = keyValuePair[..<equalSignIndex]
                let equalSignIndexOffset = keyValuePair.index(equalSignIndex, offsetBy: 1)
                let value = keyValuePair[equalSignIndexOffset...]
                
                queryStringDictionary[key] = value.removingPercentEncoding ?? ""
            }
        }
        print(queryStringDictionary)
        print("---")
        return queryStringDictionary
    }
}

