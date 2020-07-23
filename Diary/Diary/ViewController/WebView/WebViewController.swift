//
//  WebView.swift
//  Diary
//
//  Created by futami on 2019/11/20.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var wkWebView = WKWebView()
    var urlString: String?
    
    deinit {
        self.urlString = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigation()
        self.setupWebView()
        self.showWebView(self.urlString)
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let rightSearchBarButtonItem:
            UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeButton"),
                                              style: .done,
                                              target: self,
                                              action: #selector(self.closeButtonAction))
        self.navigationItem.rightBarButtonItem = rightSearchBarButtonItem
    }
    
    // webViewサイズ設定
    func setupWebView() {
        let rect = CGRect(x: .zero,
                          y: .zero,
                          width: view.frame.width,
                          height: view.frame.height)
        
        let webConfiguration = WKWebViewConfiguration()
        self.wkWebView = WKWebView(frame: rect, configuration: webConfiguration)
    }
    
    @objc func closeButtonAction() {
        self.dismiss(animated: true)
    }
    
    func showWebView(_ urlString: String?) {
        guard let urlString = urlString,
            let url = URL(string: urlString) else { return }
        let webView = URLRequest(url: url)
        self.wkWebView.load(webView)
        self.view.addSubview(self.wkWebView)
    }
}
