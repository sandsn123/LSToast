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
public struct ToastPublished {
 
    public var wrappedValue: ToastType = .dismiss

    public var projectedValue: ToastPublished { self }
    
    public var isPresenting: Bool {
        wrappedValue != .dismiss
    }
    
    public let config: ToastConfig
    public init(_ options: [ToastConfig.Option] = []) {
        self.config = ToastConfig(options: options)
    }
    
    public static subscript<OuterSelf: ObservableObject>(
        _enclosingInstance observed: OuterSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<OuterSelf, ToastType>,
        storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>
    ) -> ToastType {
        get {
            observed[keyPath: storageKeyPath].wrappedValue
        }
        set {
            if let subject = observed.objectWillChange as? ObservableObjectPublisher {
                subject.send() // 修改 wrappedValue 之前
                observed[keyPath: storageKeyPath].wrappedValue = newValue
            }
        }
    }
}
