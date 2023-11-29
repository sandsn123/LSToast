//
//  File.swift
//  
//
//  Created by czi on 2023/11/29.
//

import SwiftUI

public extension EnvironmentValues {
    var toast: ToastAction {
        get {
            return self[ToastEnvironmentKey.self]
        }
        set {
            self[ToastEnvironmentKey.self] = newValue
        }
    }
}

struct ToastEnvironmentKey: EnvironmentKey {
    static var defaultValue: ToastAction = .init(style: .dismiss)
}
