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
        let balanceVM = BalanceViewModel(dependencies: AppDependency.shared)
        let balanceVC = BalanceViewController(viewModel: balanceVM)
        balanceVC.flowDelegate = self

        let navigationController = UINavigationController(rootViewController: balanceVC)
        window.rootViewController = navigationController
        self.navigationController = navigationController
    }
}

extension AppFlowCoordinator: BalanceFlowDelegate {
    func presentAccountController(in viewController: BalanceViewController) {
        let vm = AccountViewModel(dependencies: AppDependency.shared)
        let vc = AccountViewController(viewModel: vm)
        vc.flowDelegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension AppFlowCoordinator: AccountFlowDelegate {
    func balanceActionCompleted(in viewController: AccountViewController) {
        navigationController.popViewController(animated: true)
    }
}
