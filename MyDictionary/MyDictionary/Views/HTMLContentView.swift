import SwiftUI
import WebKit

struct HTMLContentView: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let styledHTML = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                font-size: 16px;
                line-height: 1.6;
                padding: 12px;
                margin: 0;
                color: #333;
                background-color: transparent;
            }
            @media (prefers-color-scheme: dark) {
                body { color: #e0e0e0; }
                h2, h4 { color: #ffffff; }
            }
            h2 { font-size: 22px; margin-top: 8px; }
            h4 { font-size: 17px; margin-top: 12px; margin-bottom: 4px; }
            p { margin: 4px 0; }
            .s27 { color: #555; }
            .s28 { color: #666; font-style: italic; }
            .s30 { color: #0066cc; font-weight: bold; }
            .top_nav, .nav { display: none; }
            @media (prefers-color-scheme: dark) {
                .s27 { color: #aaa; }
                .s28 { color: #999; }
                .s30 { color: #4da6ff; }
            }
        </style>
        </head>
        <body>
        \(htmlContent)
        </body>
        </html>
        """
        webView.loadHTMLString(styledHTML, baseURL: nil)
    }
}
