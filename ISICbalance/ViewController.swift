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
    
    let requestManager = RequestManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            try requestManager.reloadData()
        } catch {
            
        }
    }
    
}
