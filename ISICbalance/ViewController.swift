//
//  ViewController.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 10/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

//    let balanceView = BalanceView()
    var balanceView = BalanceView()
    
    override func loadView() {
        super.loadView()
        
        self.view = balanceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = true
        self.balanceView.accountButton?.addTarget(self, action: #selector(accountBtnHandle), for: .touchDown)
        
    }
    
    @objc func accountBtnHandle() {
        let VC = AccountViewController()
        self.navigationController?.pushViewController(VC, animated: true)
//    self.present(VC, animated: true, completion: nil)
    }

}

