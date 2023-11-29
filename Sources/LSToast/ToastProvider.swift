//
//  File.swift
//  
//
//  Created by czi on 2023/10/18.
//

import Foundation
import Combine
import SwiftUI

@propertyWrapper
public struct ToastProvider {
    public var wrappedValue: ToastState
    
    public var isPresenting: Bool {
        wrappedValue.action != .dismiss
    }
    
    public init(_ options: [ToastConfig.Option] = []) {
        self.wrappedValue = ToastState(action: .dismiss, config: ToastConfig(options: options))
    }
    
    public static subscript<OuterSelf: ObservableObject>(
        _enclosingInstance observed: OuterSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<OuterSelf, ToastState>,
        storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>
    ) -> ToastState {
        get {
            observed[keyPath: storageKeyPath].wrappedValue
        }
        set {
            if let subject = observed.objectWillChange as? ObservableObjectPublisher {
                subject.send()
                observed[keyPath: storageKeyPath].wrappedValue = newValue
            }
        }
    }
}
