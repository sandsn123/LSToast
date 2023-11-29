// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

class DemoModel: ObservableObject {
    @ToastProvider([
        .complete(titleColor: .red)
    ]) var toast
}

@available(iOS 14.0, *)
struct Demo: View {
    @StateObject var vm: DemoModel = .init()
//    @Toast var toast
    var body: some View {
        ZStack {
            
            VStack {
                Circle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .onTapGesture(perform: {
                        vm.toast(.complete("Success!!!"))
                    })
                
                Button(action: {
                    vm.toast(.dismiss)
                }, label: {
                    Text("Dismiss")
                })
            }
        }
        .toast(with: $vm.toast)
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
