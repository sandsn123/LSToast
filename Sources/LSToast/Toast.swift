//
//  Toast.swift
//  CZI_Official
//
//  Created by czi on 2023/10/10.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
import Combine

public enum ToastType {
    case loading(_ text: String? = nil)
    case error(String)
    case complete(String)
    case mesage(_ title: String? = nil, text: String? = nil)
    case dismiss
}

extension ToastType: Equatable {
    public static func == (lhs: ToastType, rhs: ToastType) -> Bool {
        switch lhs {
        case .loading(let lstr):
            if case .loading(let rstr) = rhs {
                return lstr == rstr
            }
            return false
        case .error(let lerr):
            if case .error(let rerr) = rhs {
                return lerr == rerr
            }
            return false
        case .complete(let lstr):
            if case .complete(let rstr) = rhs {
                return lstr == rstr
            }
            return false
        case .mesage(let ltitle, let ltext):
            if case .mesage(let rtitle, let rtext) = rhs {
                return ltitle == rtitle && ltext == rtext
            }
            return false
        case .dismiss:
            if case .dismiss = rhs {
                return true
            }
            return false
        }
    }
}

@propertyWrapper
public struct Toast: DynamicProperty {
    @State public var wrappedValue: ToastType = .dismiss
    public let config: ToastConfig
    public var isPresenting: Bool {
        wrappedValue != .dismiss
    }
    
    public init(_ options: [ToastConfig.Option] = []) {
        self.config = ToastConfig(options: options)
    }
}

public struct ToastConfig {
    public var titleColor: Color = Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))
    public var textColor: Color = Color(#colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1))
    public var titleFont: Font = .system(size: 14, weight: .semibold)
    public var textFont: Font = .system(size: 12, weight: .regular)
    
    public var compleTitleColor = Color(#colorLiteral(red: 0.04735630006, green: 0.4727236032, blue: 0.9543274045, alpha: 1))
    public var errorTitleColor = Color(#colorLiteral(red: 0.04735630006, green: 0.4727236032, blue: 0.9543274045, alpha: 1))
    public var loadingTintColor = Color(#colorLiteral(red: 0.04735630006, green: 0.4727236032, blue: 0.9543274045, alpha: 1))
    
    public init(options: [Option] = []) {
        for option in options {
            switch option {
            case .message(let titleColor, let textColor):
                self.titleColor = titleColor
                self.textColor = textColor
            case .complete(let titleColor):
                self.compleTitleColor = titleColor
            case .error(let titleColor):
                self.errorTitleColor = titleColor
            case .loading(let tintColor):
                self.loadingTintColor = tintColor
            }
        }
    }

    public enum Option {
        case message(titleColor: Color = Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)), textColor: Color = Color(#colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)))
        case complete(titleColor: Color = Color(#colorLiteral(red: 0.04735630006, green: 0.4727236032, blue: 0.9543274045, alpha: 1)))
        case error(titleColor: Color = Color(#colorLiteral(red: 0.04735630006, green: 0.4727236032, blue: 0.9543274045, alpha: 1)))
        case loading(tintColor: Color = Color(#colorLiteral(red: 0.04735630006, green: 0.4727236032, blue: 0.9543274045, alpha: 1)))
    }
}

public extension View {
    @ViewBuilder
    func toast(with toast: Toast) -> some View {
        modifier(ToastModifier(type: toast.$wrappedValue, config: toast.config))
    }
    
    @ViewBuilder
    func toast(with type: Binding<ToastType>, config: ToastConfig) -> some View {
        modifier(ToastModifier(type: type, config: config))
    }
    
    @ViewBuilder
    func onValueChanged<T: Equatable>(of value: T, perform: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: perform)
        } else {
            self.onReceive(Just(value)) { (value) in
                perform(value)
            }
        }
    }
}

