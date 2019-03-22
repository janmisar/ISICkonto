//
//  AppViewController.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 21/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AppViewController: UIViewController {
    
    var viewModel: AppViewModel!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        bindViewToViewModel(v: view, vm: viewModel)
    }
    
    override func loadView() {
        setView()
    }
    
    
    func setView() {
        
    }
    
    func setViewModel() {
        
    }
    
    func bindViewToViewModel(v: UIView, vm: AppViewModel) {
        
    }

}
