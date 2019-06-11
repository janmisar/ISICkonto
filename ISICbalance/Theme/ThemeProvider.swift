//
//  ThemeProvider.swift
//  ISICbalance
//
//  Created by Rostislav Babáček on 27/03/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import Foundation

struct Theme<Base> { }

protocol ThemeProvider { }

extension ThemeProvider {
    static var theme: Theme<Self>.Type { return Theme<Self>.self }

    var theme: Theme<Self> { return Theme<Self>() }
}
