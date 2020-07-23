//
//  WebView.swift
//  Diary
//
//  Created by futami on 2019/11/21.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit

struct WebView {
    static func presentWebView(_ urlString: String?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "WebView", bundle: nil)
        guard let webView = storyboard.instantiateInitialViewController() else { return nil }
        if let navigation = webView as? UINavigationController,
            let webBrowser = navigation.topViewController as? WebViewController {
            webBrowser.urlString = urlString
        }
        return webView
    }
}
