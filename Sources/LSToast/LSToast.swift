// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

struct ToastDemo: View {
    
    @Toast([
        // regiular message
        .message(titleColor: .blue, textColor: .red),
        // loading
        .loading(tintColor: .blue)
    ])
    var toast
    
    var body: some View {
        ZStack {
            Color(white: 0.7).edgesIgnoringSafeArea(.all)
            
            Color.blue
                .frame(width: 100, height: 45)
                .onTapGesture {
                    action()
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
    
    func action(_ geo: GeometryProxy? = nil) {
        toast = .loading("loading...")
        
//        toast = .mesage("Title", text: "text")
//        print("top - \(geo?.safeAreaInsets.top)")
        
//        toast = .complete("Successed!!")

//        Task {
//            try? await Task.sleep(nanoseconds: 2_000_000_000)
//            toast = .error("Error!!!")
//        }
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
