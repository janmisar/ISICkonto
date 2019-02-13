//
//  LoginError.swift
//  isic_kredit
//
//  Created by Petr Dusek on 13/02/2019.
//  Copyright © 2019 Petr Dusek. All rights reserved.
//

import Foundation

enum LoginError: Error {
    case customError
}

extension LoginError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError:
            return NSLocalizedString("Login failed", comment: "")
        }
    }
}
