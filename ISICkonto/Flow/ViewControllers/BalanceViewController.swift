//
//  BalanceViewController.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 14/02/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import RxSwift

class BalanceViewController: AppViewController<BalanceViewModel, BalanceView> {
    
    var onPopBalanceViewController: () -> () = { }
   
    override func setView() {
        view = BalanceView()
    }
    
    override func setupOutputBindings(to vm: BalanceViewModel) {
        (v.refreshButton >>> vm.refreshAction).disposed(by: disposeBag)
        
        v.refreshButton.rx.tap.bind { [unowned self] in
            self.v.showLoading(with: "Loading balance...".localized)
            }.disposed(by: disposeBag)
        
        v.logOutButton.rx.tap.bind { [unowned self] in
            self.onPopBalanceViewController()
            }.disposed(by: disposeBag)
    }
    
    override func setupInputBindings(from vm: BalanceViewModel) {
        (vm.balance --> { [unowned self] in
            if $0 != "..." {
                SVProgressHUD.dismiss(withDelay: 1.0)
            } else {
                self.v.showError(with: "Failed".localized)
            }
            self.v.balanceLabel.text = $0 + " Kč"
            }).disposed(by: disposeBag)
    }
}
