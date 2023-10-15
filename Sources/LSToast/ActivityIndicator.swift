//
//  ActivityIndicator.swift
//  CZI_Official
//
//  Created by czi on 2023/10/13.
//

import SwiftUI

#if os(macOS)
@available(macOS 11, *)
public struct SaiProgressView: NSViewRepresentable {
    
    public func makeNSView(context: NSViewRepresentableContext<SaiProgressView>) -> NSProgressIndicator {
        let nsView = NSProgressIndicator()
        
        nsView.isIndeterminate = true
        nsView.style = .spinning
        nsView.startAnimation(context)
        
        return nsView
    }
    
    public func updateNSView(_ nsView: NSProgressIndicator, context: NSViewRepresentableContext<SaiProgressView>) {
    }
}
#else

@available(iOS 13, *)
public struct SaiProgressView: UIViewRepresentable {
    public var color: UIColor = .white
    public func makeUIView(context: UIViewRepresentableContext<SaiProgressView>) -> UIActivityIndicatorView {
        
        let progressView = UIActivityIndicatorView(style: .large)
        progressView.color = color
        progressView.startAnimating()
        
        return progressView
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<SaiProgressView>) {
    }
}
#endif

public struct ActivityIndicator: View {
#if !os(macOS)
    public var color: UIColor = .white
#endif
    public var body: some View {
#if os(macOS)
        SaiProgressView()
#else
        if #available(iOS 15.0, *) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(color)))
                .controlSize(.large)
        } else {
            SaiProgressView(color: color)
        }
#endif
    }
}

