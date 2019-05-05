//
//  Base.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 15/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        NSLog("📱 👶 \(self)")
    }
    
    deinit {
        NSLog("📱 ⚰️ \(self)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class BaseViewModel {
    
    init() {
        NSLog("🧠 👶 \(self)")
    }
    
    deinit {
        NSLog("🧠 ⚰️ \(self)")
    }
}

class BaseFlowCoordinator {
    init() {
        NSLog("🔀 👶 \(self)")

    }

    deinit {
        NSLog("🔀 ⚰️ \(self)")
    }
}
