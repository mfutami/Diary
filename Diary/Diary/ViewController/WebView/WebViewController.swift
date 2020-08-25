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
    var progressView = UIProgressView()
    var urlString: String?
    
    deinit {
        self.urlString = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigation()
        self.setupWebView()
        self.setupProgressView()
        self.showWebView(self.urlString)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            self.progressView.alpha = 1.0
            // estimatedProgressが変更されたときにプログレスバーの値を変更
            self.progressView.setProgress(Float(self.wkWebView.estimatedProgress), animated: true)
            
            // estimatedProgressが1.0になったらアニメーションを使って非表示にしアニメーション完了時0.0をセットする
            if (self.wkWebView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: [.curveEaseOut], animations: { [weak self] in
                    self?.progressView.alpha = .zero
                    }, completion: { (finished : Bool) in
                        self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
}

private extension WebViewController {
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
        let rect = CGRect(x: .zero, y: .zero,
                          width: view.frame.width,
                          height: view.frame.height)
        
        let webConfiguration = WKWebViewConfiguration()
        self.wkWebView = WKWebView(frame: rect, configuration: webConfiguration)
    }
    
    func setupProgressView() {
        self.progressView = UIProgressView(frame: CGRect(x: 0.0,
                                                         y: (self.navigationController?.navigationBar.frame.size.height ?? .zero) - 2,
                                                         width: self.view.frame.size.width,
                                                         height: 2))
        self.progressView.progressViewStyle = .bar
        self.navigationController?.navigationBar.addSubview(self.progressView)
        
        // KVO 監視
        self.wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.wkWebView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
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
