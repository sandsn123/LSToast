//
//  File.swift
//  
//
//  Created by czi on 2023/10/18.
//

import Foundation
import Combine

@propertyWrapper
public struct ToastPublished {
 
    public var wrappedValue: ToastType = .dismiss {
        willSet {  // 修改 wrappedValue 之前
            publisher.subject.send(newValue)
        }
    }

    public var projectedValue: Publisher {
        publisher
    }

    private var publisher: Publisher = .init(.dismiss)

    public struct Publisher: Combine.Publisher {
        public typealias Output = ToastType
        public typealias Failure = Never

        var subject: CurrentValueSubject<ToastType, Never> // PassthroughSubject 会缺少初始话赋值的调用

        public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            subject.subscribe(subscriber)
        }

        init(_ output: ToastType) {
            subject = .init(output)
        }
    }
    
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
