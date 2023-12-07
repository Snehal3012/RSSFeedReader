//
//  WebView.swift
//  RSSFeedReader
//
//  Created by Snehal Firodia on 05/12/23.
//

import SwiftUI
import WebKit

struct WebView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    @State var url: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                WebViewRepresentable(isLoading: $isLoading, url: $url)
                    .frame(maxHeight: .infinity)
                if isLoading {
                    ProgressView()
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black, Color(uiColor: .tertiarySystemFill))
                            .contentShape(Rectangle())
                    }
                }
            }
        }
    }
}

#Preview {
    WebView(url: "https://www.google.com")
}

