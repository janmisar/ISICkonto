//
//  UITextField+Theme.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 27/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit

extension UITextField: ThemeProvider { }

extension Theme where Base: UITextField {
//    static var labelBlue: UIColor { return UIColor(red: 171/255, green: 213/255, blue: 242/255, alpha: 1) }

    static var formTextField: UITextField {
        let textField = UITextField()

        textField.backgroundColor = UIColor.theme.textFieldBackground
        textField.textColor = UIColor.theme.textColor
        textField.tintColor = UIColor.theme.textColor
        textField.setLeftPaddingPoints(5)
        textField.layer.cornerRadius = 2
        textField.layer.masksToBounds = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none

        textField.snp.makeConstraints { (make) in
            make.height.equalTo(45)
        }

        return textField
    }
}
