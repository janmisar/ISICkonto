//
//  FailError.swift
//  isic_kredit
//
//  Created by Petr Dusek on 13/02/2019.
//  Copyright © 2019 Petr Dusek. All rights reserved.
//

import Foundation

enum FailError: Error {
    case customError
    
}

extension FailError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError:
            return NSLocalizedString("Fail", comment: "")
        }
    }
}
