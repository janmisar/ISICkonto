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

class BalanceViewController: AppViewController {
    
    var onPopBalanceViewController: () -> () = { }
   
    override func setView() {
        view = BalanceView()
    }
    
    override func setViewModel() {
        viewModel = BalanceViewModel()
    }
    
    override func bindViewToViewModel(v: UIView, vm: AppViewModel) {
        let balanceView = v as! BalanceView
        let vm = vm as! BalanceViewModel
        
        // Output bindings
        (balanceView.refreshButton >>> vm.refreshAction).disposed(by: disposeBag)
        
        balanceView.logOutButton.rx.tap.bind { [unowned self] in
            self.onPopBalanceViewController()
            }.disposed(by: disposeBag)
        
        // Input bindings
        (vm.balance --> { [unowned balanceView] in
            balanceView.balanceLabel.text = $0 + " Kč"
            }).disposed(by: disposeBag)
    }
}
