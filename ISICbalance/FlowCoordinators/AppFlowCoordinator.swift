//
//  AppFlowCoordinator.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 05/05/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit

class AppFlowCoordinator: BaseFlowCoordinator {
    public var childCoordinators = [BaseFlowCoordinator]()

    weak var navigationController: UINavigationController!

    func start(in window: UIWindow) {

        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        self.navigationController = navigationController

        let balanceVM = BalanceViewModel(dependencies: AppDependency.shared)
        let balanceVC = BalanceViewController(viewModel: balanceVM)
        balanceVC.flowDelegate = self
        navigationController.setViewControllers([balanceVC], animated: true)
    }
}

extension AppFlowCoordinator: BalanceFlowDelegate {
//    func accountButtonTapped(in viewController: BalanceViewController) {
//        let vm = AccountViewModel(dependencies: AppDependency.shared)
//        let vc = AccountViewController(
//    }
}
