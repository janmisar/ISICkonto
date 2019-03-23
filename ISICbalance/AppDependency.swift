//
//  AppDependency.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 23/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation

protocol HasNoDependency { }

final class AppDependency: HasNoDependency {
    private init() { }
    static let shared = AppDependency()

    lazy var requestManager: RequestManagering = RequestManager()
    lazy var keychainManager: KeychainManagering = KeychainManager()
}

extension AppDependency: HasRequestManager { }
extension AppDependency: HasKeychainManager { }
