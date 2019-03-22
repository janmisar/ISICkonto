//
//  UIView.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 17/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func set(alpha: CGFloat, duration: TimeInterval = 0.2) {
        UIView.transition(with: self, duration: duration, animations: { [weak self] in
            self?.alpha = alpha
        })
    }
}
