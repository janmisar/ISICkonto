//
//  UIColor+Theme.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 27/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit

extension UIColor: ThemeProvider { }

extension Theme where Base: UIColor {
    static var labelBlue: UIColor { return UIColor(red: 171/255, green: 213/255, blue: 242/255, alpha: 1) }
    static var backgroundColor: UIColor { return UIColor(red: 75/255, green: 150/255, blue: 179/255, alpha: 1) }
    static var textFieldBackground: UIColor { return UIColor(red: 55/255, green: 131/255, blue: 160/255, alpha: 1) }
    static var textColor: UIColor { return UIColor.white }
}
