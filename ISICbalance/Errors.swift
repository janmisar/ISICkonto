//
//  Errors.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 14/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

enum RequestError: Error {
    case agataGetError(error: Error)
    case ssoGetError(error: Error)
    case credentialsPostError(error: Error)
    case balanceScreenPostError(error: Error)
    case parseError
    case credentialsError(LoginValidation)
    case loginFailed
    case actionError
}

enum LoginError: Error {
    case invalidCredentials
    case keychainCredentialsFailed
    case validation([LoginValidation])
}

enum SwiftSoupError: Error {
    case parseLoginSite(error: Error)
}

enum LoginValidation: Error {
    case username
    case password
}
