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
import SwiftUIMisc

public enum ToastStyle {
    case loading(_ style: ActivityIndicator.Style = .medium, _ text: String? = nil)
    case error(String)
    case complete(String)
    case mesage(_ title: String? = nil, text: String? = nil)
    case dismiss
}

extension ToastStyle: Equatable {
    public static func == (lhs: ToastStyle, rhs: ToastStyle) -> Bool {
        switch lhs {
        case .loading(_, let lstr):
            if case .loading(_, let rstr) = rhs {
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
    @State public var wrappedValue: ToastAction
    
    public var projectedValue: Binding<ToastAction> {
        Binding {
            wrappedValue
        } set: {
            wrappedValue = $0
        }
    }
    
    public var isPresenting: Bool {
        wrappedValue.style != .dismiss
    }
    
    public init(_ options: [ToastConfig.Option] = []) {
        self._wrappedValue = State(initialValue: ToastAction(style: .dismiss, config: ToastConfig(options: options)))
    }
}

public struct ToastAction: Equatable {
    private(set) var style: ToastStyle = .dismiss
    public let config: ToastConfig
    
    mutating public func callAsFunction(_ value: ToastStyle) {
        style = value
    }

    public static func == (lhs: ToastAction, rhs: ToastAction) -> Bool {
        return lhs.style == rhs.style
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
    
    public var indicatorStyle: ActivityIndicator.Style = .medium
    
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
            case .loading(let style, let tintColor):
                self.indicatorStyle = style
                self.loadingTintColor = tintColor
            }
        }
    }

    public enum Option {
        case message(titleColor: Color = Color(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)), textColor: Color = Color(#colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)))
        case complete(titleColor: Color = Color(#colorLiteral(red: 0.04735630006, green: 0.4727236032, blue: 0.9543274045, alpha: 1)))
        case error(titleColor: Color = Color(#colorLiteral(red: 0.04735630006, green: 0.4727236032, blue: 0.9543274045, alpha: 1)))
        case loading(style: ActivityIndicator.Style, tintColor: Color = Color(#colorLiteral(red: 0.04735630006, green: 0.4727236032, blue: 0.9543274045, alpha: 1)))
    }
}

public extension View {
    @ViewBuilder
    func toast(with toast: Binding<ToastAction>) -> some View {
        modifier(ToastModifier(type: toast))
    }
    
//    @ViewBuilder
//    func toast(with type: Binding<ToastAction>, config: ToastConfig) -> some View {
//        modifier(ToastModifier(type: type, config: config))
//    }
}
