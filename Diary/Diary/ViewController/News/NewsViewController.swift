//
//  NewsViewController.swift
//  Diary
//
//  Created by futami on 2019/09/08.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController, XMLParserDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    private var newsArrey = [Any]()
    
    var viewModel = NewsViewModel()
    
    var newsTitle = [String]()
    var newsLink = [String]()
    var newsImage = [String]()
    
    var topPadding: CGFloat = 0
    
    var urlString: String?
    private var refresh = UIRefreshControl()
    
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.news)
        self.setupTableView()
        
        self.tableView.refreshControl = self.refresh
        self.refresh.addTarget(self, action: #selector(self.refreshControl(sender:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.completionXmlPaser()
    }
    
    deinit {
        self.newsTitle = [""]
        self.newsImage = [""]
        self.newsLink = [""]
    }
    // Navugation Bar
    func setupNavigation(_ setTitle: navigationTitle) {
        self.title = setTitle.title
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    @objc func refreshControl(sender: UIRefreshControl) {
        self.completionXmlPaser()
    }
    
    func completionXmlPaser() {
        self.xmlPaser { [weak self] in
            guard let wself = self else { return }
            wself.tableView.reloadData()
            wself.refresh.endRefreshing()
        }
    }
    func xmlPaserRx() {
        self.viewModel.xmlPaserRxSwift()
            .subscribeOn(backgroundScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe (
                .map {[weak self] in
                    guard let wself = self else { return }
                })
            .disposed(by: disposeBag)
    }
    
    func xmlPaser(completion: (() -> Void)? = nil) {
        Alamofire.request(self.viewModel.url, method: .get, parameters: nil).response { response in
            guard let date = response.data else { return }
            let xml = SWXMLHash.parse(date)
            for xmls in xml["rss"]["channel"]["item"].all {
                guard let title = xmls["title"].element?.text,
                    let link = xmls["link"].element?.text,
                    let image = xmls["enclosure"].element?.attribute(by: "url")?.text else { return }
                self.newsTitle.append(title)
                self.newsLink.append(link)
                self.newsImage.append(image)
            }
            defer { completion?() }
        }
    }
}

extension NewsViewController {
    func setupTableView() {
        self.tableView.register(UINib(nibName: NewsTableViewCell.identifier, bundle: nil),
                                forCellReuseIdentifier: NewsTableViewCell.identifier)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .singleLine
        self.tableView.allowsSelection = true
        self.tableView.backgroundColor = .clear
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let identifier = NewsTableViewCell.identifier
        cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let newsCell = cell as? NewsTableViewCell {
            let newsTitle = self.newsTitle[indexPath.row]
            let newsImage = self.newsImage[indexPath.row]
            newsCell.setupCell(title: newsTitle, imageUrl: newsImage)
        }
        return cell
    }
}
extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.urlString = self.newsLink[indexPath.row]
        guard let viewController = WebView.presentWebView(self.urlString) else { return }
        self.present(viewController, animated: true, completion: nil)
        // cell選択状態解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

