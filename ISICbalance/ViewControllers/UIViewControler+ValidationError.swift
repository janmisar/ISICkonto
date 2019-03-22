//
//  UIViewControler+ValidationError.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 22/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import UIKit

protocol ValidateErrorPresentable {
    func present(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?)
}

extension ValidateErrorPresentable {
    func present(_ controller: UIViewController, animated: Bool) {
        return present(controller, animated: animated, completion: nil)
    }
}

extension ValidateErrorPresentable {
    func presentValidationError(_ errorMessage: String) {
        let alertController = UIAlertController(title: "Validation error!", message: errorMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)

        present(alertController, animated: true)
    }
}
