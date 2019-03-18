//
//  Result.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 13/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation

public enum ResultInformation {
    case inProgress, success, failure, loggedIn
}

public struct Result<Element> {
    public let info: ResultInformation
    public let message: String?
    public let element: Element?
    
    static public func resultFailed(_ message: String? = nil) -> Result { return Result(info: .failure, message: message, element: nil) }
    static public func resultSuccess(_ message: String? = nil, element: Element) -> Result { return Result(info: .success, message: message, element: element) }
    static public func resultInProgress() -> Result { return Result(info: .inProgress, message: nil, element: nil) }
    static public func resultLoggedIn(_ message: String? = nil, element: Element) -> Result { return Result(info: .loggedIn, message: nil, element: element) }
}
