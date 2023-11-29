//
//  File.swift
//  
//
//  Created by czi on 2023/11/29.
//

import SwiftUI

extension EnvironmentValues {
    var toast: Toast {
        get {
            return self[ToastEnvironmentKey.self]
        }
        set {
            self[ToastEnvironmentKey.self] = newValue
        }
    }
}

struct ToastEnvironmentKey: EnvironmentKey {
    static var defaultValue: Toast = .init()
}
