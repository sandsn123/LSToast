//
//  File.swift
//  
//
//  Created by sandsn on 2023/10/15.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
import Combine

struct Const {
    static var screen: CGRect {
#if os(iOS)
        return UIScreen.main.bounds
#else
        return NSScreen.main?.frame ?? .zero
#endif
    }

    static var topSpace: CGFloat {
#if os(iOS)
        let window = UIApplication.shared.windows.first
        return window?.safeAreaInsets.top ?? 0
#else
        return 0
#endif
    }
}

#if os(macOS)
    typealias UIColor = NSColor
#endif

extension Color {
 
    func uiColor() -> UIColor {

        if #available(iOS 14.0, *) {
            return UIColor(self)
        }

        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}
