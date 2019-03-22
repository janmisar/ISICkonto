//
//  BindingOperators.swift
//  ISICkonto
//
//  Created by Vendula Švastalová on 18/03/2019.
//  Copyright © 2019 Vendula Švastalová. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

infix operator >>>
infix operator -->

public func >>> (button: UIButton, to: Variable<Void>)  -> Disposable {
    return button.rx.tap.bind(to: to)
}

public func >>> (textField: UITextField, to: Variable<String>) -> Disposable {
    return textField.rx.text.orEmpty.asObservable().bind(to: to)
}

public func --> <Element>(observable: Observable<Element>, closure: @escaping (Element) -> ()) -> Disposable {
    return observable.subscribe(onNext: { closure($0) })
}
