//
//  AppView.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 21/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import UIKit
import SVProgressHUD

class AppView: UIView {
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        createConstraints()
    }
    
    func setupUI() {
        
    }
    
    func createConstraints() {
        
    }
    
    func showSuccess(with message: String) {
        SVProgressHUD.showSuccess(withStatus: message)
        SVProgressHUD.dismiss(withDelay: 1.0)
    }
    
    func showError(with message: String) {
        SVProgressHUD.showError(withStatus: message)
        SVProgressHUD.dismiss(withDelay: 1.0)
    }
    
    func showLoading(with message: String) {
        SVProgressHUD.show(withStatus: message)
    }

}
