//
//  YouTubePlayerView.swift
//  FetchMobileTakeHomeProject
//
//  Created by Crossley Rozario on 11/15/24.
//

import SwiftUI
import WebKit

struct YouTubePlayerView: View {
    @Environment(\.presentationMode) var presentationMode
    let url: String
    let navigationTitle: String

    var body: some View {
        NavigationView {
            if let videoURL = URL(string: url) {
                WebView(url: videoURL)
                    .navigationBarTitle("\(navigationTitle) Video", displayMode: .inline)
                    .navigationBarItems(trailing: Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    })
            } else {
                Text("Invalid YouTube URL")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
