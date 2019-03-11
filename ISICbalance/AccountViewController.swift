//
//  AccountViewController.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 11/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    let accountView = AccountView()

    override func loadView() {
        super.loadView()
        
        self.view = accountView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = L10n.Login.title

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
