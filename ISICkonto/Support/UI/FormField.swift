//
//  FormField.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 15/02/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import UIKit

class FormField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor(red: 74/255, green: 130/255, blue: 157/255, alpha: 1)
        self.layer.cornerRadius = 5.0
        
        self.textColor = UIColor.white
        self.tintColor = UIColor.white
        
        self.font = UIFont(name: "Cabin-Regular", size: 17)!
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
}
