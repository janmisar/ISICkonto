//
//  String.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 15/02/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation

public extension String {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
