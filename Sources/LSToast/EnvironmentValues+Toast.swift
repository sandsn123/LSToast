//
//  File.swift
//  
//
//  Created by czi on 2023/11/29.
//

import SwiftUI

public extension EnvironmentValues {
    var toast: Binding<ToastAction> {
        get {
            return self[ToastEnvironmentKey.self]
        }
        set {
            self[ToastEnvironmentKey.self] = newValue
        }
    }
}

struct ToastEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<ToastAction> = .constant(.init(style: .dismiss))
}

extension Binding where Value == ToastAction {
    public func callAsFunction(_ value: ToastStyle) {
        wrappedValue(value)
    }
}
