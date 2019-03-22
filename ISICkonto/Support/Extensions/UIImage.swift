//
//  UIImage.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 22/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    enum ImageId: String {
        case logo
        case reloadIcon
        case accountIcon
    }
    
    convenience init(id: ImageId) {
        self.init(named: id.rawValue)!
    }
}
