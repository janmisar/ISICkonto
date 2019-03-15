//
//  FormTextField.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 15/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit

class FormTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.MyTheme.textFieldBackground
        self.textColor = UIColor.MyTheme.textColor
        self.tintColor = UIColor.MyTheme.textColor
        self.setLeftPaddingPoints(5)
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
