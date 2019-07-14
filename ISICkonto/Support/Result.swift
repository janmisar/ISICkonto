//
//  Result.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 13/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation

enum ResultInformation {
    case inProgress, success, failure, loggedIn
}

struct Result<Element> {
    let info: ResultInformation
    let message: String?
    let element: Element?
    
    static func resultFailed(_ message: String? = nil) -> Result { return Result(info: .failure, message: message, element: nil) }
    static func resultSuccess(_ message: String? = nil, element: Element) -> Result { return Result(info: .success, message: message, element: element) }
    static func resultInProgress() -> Result { return Result(info: .inProgress, message: nil, element: nil) }
    static func resultLoggedIn(_ message: String? = nil, element: Element) -> Result { return Result(info: .loggedIn, message: nil, element: element) }
}
