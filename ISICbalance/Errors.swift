//
//  Errors.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 14/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

enum RequestError {
    case agataGetError(error: Error)
    case ssoGetError(error: Error)
    case credentialsPostError(error: Error)
    case balanceScreenPostError(error: Error)
}

enum LoginError {
    case loginFailed
}

enum SwiftSoupError {
    case parseLoginSite(error: Error)
}
