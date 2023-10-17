// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

struct ToastDemo: View {
    
    // custom style
//    @Toast([
//        // regiular message
//        .message(titleColor: .blue, textColor: .red),
//        // loading
//        .loading(tintColor: .blue)
//    ])
    
    @Toast  // default
    var toast
    
    var body: some View {
        ZStack {
            Color(white: 0.7).edgesIgnoringSafeArea(.all)
            
            Color.blue
                .frame(width: 100, height: 45)
                .onTapGesture {
                    toast = .loading("Loading...")
                    
                    Task {
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        toast = .error("Error!!!")
                    }
                }
   
            Button(action: {
                toast = .dismiss
            }, label: {
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(.red)
                    .overlay(
                        Text("Dismiss")
                            .font(.title)
                            .foregroundColor(.white)
                    )
            })
            .offset(y: 80)
            .frame(width: 100, height: 45)
        }
        .toast(with: _toast)
    }
}


#Preview {
    NavigationView {
        ToastDemo()
        #if os(macOS)
            .navigationTitle("Title")
        #else
            .navigationBarTitle(Text("title"), displayMode: .large)
        #endif
            
    }
//    ToastDemo()
}
