//
//  ToastView.swift
//  CZI_Official
//
//  Created by czi on 2023/10/13.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    
    @Binding var toastType: ToastType
    var config: ToastConfig
    @State var appearWorkItem: DispatchWorkItem?
    
    init(type: Binding<ToastType>, config: ToastConfig) {
        self._toastType = Binding(get: {
            type.wrappedValue
        }, set: { value in
            withAnimation {
                type.wrappedValue = value
            }
        })
        self.config = config
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                stateView
            )
    }

    var stateView: some View {
        ToastStateView(toastType: toastType, config: config)
            .onValueChanged(of: toastType, perform: { newValue in
                if let appearWorkItem {
                    appearWorkItem.cancel()
                    self.appearWorkItem = nil
                }
               
                appearAction()
            })
            .onAppear(perform: {
                appearAction()
            })
            .onDisappear(perform: {
                if let appearWorkItem {
                    appearWorkItem.cancel()
                    self.appearWorkItem = nil
                }
            })
            .animation(.spring, value: toastType)
    }
    
    func appearAction() {
        guard appearWorkItem == nil else {
            return
        }
        if case .dismiss = toastType {
            return
        } else if case .loading = toastType {
            return
        } else {
            let workItem = DispatchWorkItem {
                toastType = .dismiss
            }

            appearWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: workItem)
        }
    }
}

struct ToastStateView: View {
    var toastType: ToastType
    var config: ToastConfig
    var stateOffset: CGFloat {
        let alignment = (hostSize.height - stateSize.height) * 0.5
        if case .mesage = toastType {
            return Const.topSpace - alignment
        }
        return (Const.screen.height - stateSize.height) * 0.5 - alignment
    }

    @State var stateSize: CGSize = .zero
    @State var hostSize: CGSize = .zero
    @State private var topOffsetY: CGFloat? = nil
    
    var body: some View {
        
        GeometryReader { geometry in
            update(with: geometry)
        }
        .overlay(
            stateView
                .sizeReader(for: $stateSize)
                .offset(y: stateOffset)
                .animation(.default, value: stateOffset)
        )
        .offset(y: -(topOffsetY ?? 0))
    }
    
    func update(with geo: GeometryProxy) -> some View {
        let rect = geo.frame(in: .global)
        
        if self.topOffsetY == nil {
            DispatchQueue.main.async {
                self.topOffsetY = rect.minY
                self.hostSize = rect.size
            }
        }
        return Color.clear
    }
    
    @ViewBuilder
    var stateView: some View {
        switch toastType {
        case .loading(let text):
            loadingView
                .modifier(TitleBackgroundModifier(title: text, titleColor: config.loadingTintColor))
                .transition(.opacity)
        case .error(let desc):
            AnimatedMark(type: .failure)
                .modifier(TitleBackgroundModifier(title: desc, titleColor: config.errorTitleColor))
                .transition(.opacity)
        case .complete(let string):
            AnimatedMark(type: .success)
                .modifier(TitleBackgroundModifier(title: string, titleColor: config.compleTitleColor))
                .transition(.opacity)
        case .mesage(let title, let text):
            HudTip(title: title, text: text, titleColor: config.titleColor,
                   textColor: config.textColor, titleFont: config.titleFont, textFont: config.textFont)
                .sizeReader(for: $stateSize)
                .transition(.move(edge: .top).combined(with: .opacity))
            
        case .dismiss:
            EmptyView()
        }
    }
    
    var loadingView: some View {
#if os(macOS)
        ActivityIndicator()
#else
        ActivityIndicator(color: config.loadingTintColor.uiColor())
#endif
    }
}


fileprivate struct AnimatedMark: View {
    ///Checkmark color
    var color: Color = .white
    var type: MarkShape.Mode
    @State private var percentage: CGFloat = .zero
    
    let wh: CGFloat = 20.0
    let bg1 = #colorLiteral(red: 0.2506295443, green: 0.5538730025, blue: 0.9573871493, alpha: 1)
    let bg2 = #colorLiteral(red: 0.04735630006, green: 0.4727236032, blue: 0.9543274045, alpha: 1)
    var body: some View {
        Circle()
            .fill(Color(bg1))
            .frame(width: 54, height: 54)
            .overlay(
                Circle()
                    .fill(Color(bg2))
                    .frame(width: 46, height: 46)
                    .overlay(
                        mark
                            .frame(width: wh, height: wh)
                    )
            )
    }
    
    var mark: some View {
        MarkShape(mode: type)
        .trim(from: 0, to: percentage)
        .stroke(color, style: StrokeStyle(lineWidth: CGFloat(3), lineCap: .square, lineJoin: .miter))
        .animation(Animation.spring().speed(0.75).delay(0.25), value: percentage)
        .onAppear {
            percentage = 1.0
        }
    }
}

struct MarkShape: Shape {
    enum Mode {
        case success
        case failure
    }
    var mode: Mode = .success
  
    func path(in rect: CGRect) -> Path {
        switch mode {
        case .success:
            Path { path in
                path.move(to: CGPoint(x: 0, y: rect.height / 2.0))
                path.addLine(to: CGPoint(x: rect.width / 2.5, y: rect.height))
                path.addLine(to: CGPoint(x: rect.width, y: 2.0))
            }
        case .failure:
            Path { path in
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxY, y: rect.maxY))
                path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            }
        }
        
    }
}


struct TitleBackgroundModifier: ViewModifier {
    var title: String?
    var titleColor: Color
    func body(content: Content) -> some View {
        
        VStack(spacing: 20) {
            content
            
            if let title {
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14))
                    .foregroundColor(titleColor)
            }
        }
        .frame(minWidth: 80, minHeight: 80)
        .padding()
        .background(
            blur
        )
        .frame(maxWidth: 150)
    }
    
    var blur: some View {
        #if os(macOS)
        BlurView()
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .shadow(radius: 10)
        #else
        BlurView(style: .systemMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .shadow(radius: 10)
        #endif
    }
}

struct HudTip: View {
    let title: String?
    let text: String?
    let titleColor: Color
    let textColor: Color
    let titleFont: Font
    let textFont: Font
    
    var body: some View {
        VStack(spacing: 5) {
            if let title {
                Text(title)
                    .font(titleFont)
                    .foregroundColor(titleColor)
            }
            
            if let text {
                Text(text)
                    .font(textFont)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(10)
        .frame(minWidth: 120)
        .background(
            blur
        )
        .frame(maxWidth: 250)
    }
    
    var blur: some View {
        #if os(macOS)
        BlurView()
            .clipShape(Capsule())
            .shadow(radius: 10)
        #else
        BlurView(style: .systemMaterial)
            .clipShape(Capsule())
            .shadow(radius: 10)
        #endif
    }
}
