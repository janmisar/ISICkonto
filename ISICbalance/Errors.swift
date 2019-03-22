//
//  Errors.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 14/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

enum RequestError: Error {
    case agataGetError(message: String)
    case ssoGetError(message: String)
    case credentialsPostError(message: String)
    case balanceScreenPostError(message: String)
    case parseError(message: String)
    case credentialsError(LoginValidation)
    case loginFailed(message: String)
    case actionError(message: String)
}

enum LoginError: Error {
    case keychainCredentialsFailed(message: String)
    case validation([LoginValidation])
    case actionError(message: String)
}

enum SwiftSoupError: Error {
    case parseLoginSite(error: Error)
}

enum LoginValidation: Error {
    case username(message: String)
    case password(message: String)
}
