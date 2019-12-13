//
//  NewsViewController.swift
//  Diary
//
//  Created by futami on 2019/09/08.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit
import SWXMLHash
import RxSwift
import RxCocoa

class NewsViewController: UIViewController, XMLParserDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    let url = "https://toyokeizai.net/list/feed/rss"
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    private let disposeBag = DisposeBag()
    
    var newsTitle = [String]()
    var newsLink = [String]()
    var newsImage = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.news)
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.xmlPaser()
    }
    // Navugation Bar
    func setupNavigation(_ setTitle: navigationTitle) {
        self.title = setTitle.title
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    func xmlPaser() {
        Alamofire.request(self.url,method: .get, parameters: nil).response { response in
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
            self.tableView.reloadData()
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
        self.tableViewHight()
    }
    
    func tableViewHight() {
        self.tableViewHeight.constant = self.tableView.contentSize.height
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
            let newsLink = self.newsLink[indexPath.row]
            let newsImage = self.newsImage[indexPath.row]
            newsCell.setupCell(title: newsTitle, imageUrl: newsImage, link: newsLink)
        }
        return cell
    }
}

