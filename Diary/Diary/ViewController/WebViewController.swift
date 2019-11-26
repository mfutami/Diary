//
//  webView.swift
//  Diary
//
//  Created by futami on 2019/11/20.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var wkWebView = WKWebView()
    var topPadding: CGFloat = 0
    var urlString: String?
    
    //    var getUrlString: String? {
    //        get {
    //            return self.urlString
    //        }
    //        set {
    //            self.urlString = newValue
    //        }
    //    }
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
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.closeButtonAction))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
    }
    
    // webViewサイズ設定
    func setupWebView() {
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        let rect = CGRect(x: 0,
                          y: topPadding,
                          width: screenWidth,
                          height: screenHeight - topPadding)
        
        let webConfiguration = WKWebViewConfiguration()
        self.wkWebView = WKWebView(frame: rect, configuration: webConfiguration)
    }
    
    @objc func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showWebView(_ urlString: String?) {
        guard let urlString = urlString,
            let url = URL(string: urlString) else { return }
        let webView = URLRequest(url: url)
        self.wkWebView.load(webView)
        self.view.addSubview(self.wkWebView)
    }
}
