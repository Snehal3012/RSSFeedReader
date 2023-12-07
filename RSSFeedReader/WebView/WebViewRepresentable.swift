//  Created by Snehal Firodia on 19/10/23.
//  Copyright © 2023 Skarvo Inc. All rights reserved.

import SwiftUI
import WebKit

final class RichEditorWebView: WKWebView {
    private var accessoryView: UIView?
    
    override var inputAccessoryView: UIView? {
        accessoryView
    }
}

struct WebViewRepresentable: UIViewRepresentable {
    @Binding var isLoading: Bool
    @Binding var url: String
    
    func makeUIView(context: Context) -> RichEditorWebView  {
        let wkwebView = RichEditorWebView()
        wkwebView.scrollView.contentInset = UIEdgeInsets.zero;
        wkwebView.navigationDelegate = context.coordinator
        if let loadUrl = URL(string: url) {
            let request = URLRequest(url: loadUrl)
            wkwebView.load(request)
        }
        return wkwebView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: RichEditorWebView, context: Context) {

    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewRepresentable
        
        init(_ parent: WebViewRepresentable) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let urlString = webView.url?.absoluteString{
                parent.url = urlString
            }
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

        }
    }
}

#Preview {
    WebViewRepresentable(
        isLoading: .constant(true),
        url: .constant( "https://www.google.com/")
    )
}
