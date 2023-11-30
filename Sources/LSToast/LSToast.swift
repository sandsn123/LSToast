// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

class DemoModel: ObservableObject {
    @ToastProvider([
        .complete(titleColor: .red),
        .loading(style: .large, tintColor: .red)
    ]) var toast
}

@available(iOS 14.0, *)
struct Demo: View {
    @StateObject var vm: DemoModel = .init()
    @Toast var toast
    var body: some View {
        ZStack {
            
            VStack(spacing: 30) {
                Circle()
                    .fill(.red)
                    .overlay(Text("Tap to toast"))
                    .frame(width: 200, height: 200)
                    .onTapGesture(perform: {
                        toast(.loading())
                    })
                
                Button(action: {
                    toast(.dismiss)
                }, label: {
                    Text("Dismiss")
                })
                
                ChildView()
                    .environment(\.toast, $toast)
            }
        }
        .toast(with: $toast)
    }
}

struct ChildView: View {
    @Environment(\.toast) var toast
    var body: some View {
        Text("ChildView")
            .onTapGesture {
                toast(.complete("ChildView complete!!"))
            }
    }
}

#Preview {
    if #available(iOS 14.0, *) {
        return Demo()
    } else {
        // Fallback on earlier versions
        return EmptyView()
    }
}
