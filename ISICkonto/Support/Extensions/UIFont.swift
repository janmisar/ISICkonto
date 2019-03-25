//
//  UIFont.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 18/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    class func cabinRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Cabin-Regular", size: size)!
    }
    
    class func cabinBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Cabin-Bold", size: size)!
    }
    
    class func cabinMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Cabin-Medium", size: size)!
    }
}
