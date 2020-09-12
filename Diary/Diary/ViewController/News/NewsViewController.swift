//
//  NewsViewController.swift
//  Diary
//
//  Created by futami on 2019/09/08.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SWXMLHash

class NewsViewController: UIViewController, XMLParserDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var layout = UICollectionViewFlowLayout()
    
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    private let disposeBag = DisposeBag()
    
    private let indicator = Indicator()
    
    private var viewModel = NewsViewModel()
    
    var newsTitle = [String]()
    var newsLink = [String]()
    var newsImage = [String]()
    
    var titleString = [String]()
    var link = [String]()
    var image = [String]()
    
    var maxCollection: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.news)
        self.setupTableView()
        self.setupCollectionView()
        self.indicator.indicatorSetup(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notification = NotificationCenter.default
        notification.addObserver(self,
                                 selector: #selector(self.willEnterForeground(_:)),
                                 name: UIApplication.willEnterForegroundNotification,
                                 object: nil)
        notification.addObserver(self,
                                 selector: #selector(self.didEnterBackground(_:)),
                                 name: UIApplication.didEnterBackgroundNotification,
                                 object: nil)
        self.getNews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeDate()
    }
    
    @objc func didEnterBackground(_ notification: Notification?) {
        self.removeDate()
    }
    
    @objc func willEnterForeground(_ notification: Notification?) {
        self.getNews()
    }
}
// MARK: - NewsViewController
private extension NewsViewController {
    
    // MARK: - Navugation Bar
    
    func setupNavigation(_ setTitle: NavigationTitle) {
        self.navigationController?.navigationItem(title: setTitle.title,
                                                  viewController: self)
    }
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: NewsTableViewCell.identifier, bundle: nil),
                                forCellReuseIdentifier: NewsTableViewCell.identifier)
        self.tableView.allowsSelection = true
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        
        self.tableView.alwaysBounceVertical = true
        
        self.tableViewHeight.constant = self.tableView.contentSize.height
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setupCollectionView() {
        self.collectionView.register(UINib(nibName: NewsCollectionViewCell.identifier, bundle: nil),
                                     forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        self.layout.itemSize = self.collectionView.bounds.size
        self.layout.minimumInteritemSpacing = self.collectionView.bounds.height
        self.layout.scrollDirection = .horizontal
        self.layout.minimumInteritemSpacing = 20
        
        self.collectionViewWidth.constant = self.collectionView.contentSize.width
        
        self.collectionView.collectionViewLayout = self.layout
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func newsInfoAcquisitionProcess(completion: (() -> Void)? = nil) {
        self.indicator.start()
        self.viewModel.newsInfoAcquisitionProcess()
            .subscribeOn(backgroundScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe (
                onNext: { [weak self] date in
                    guard let wself = self else { return }
                    defer { wself.indicator.stop() }
                    var counto: Int = .zero
                    SWXMLHash.parse(date)["rss"]["channel"]["item"].all.forEach {
                        guard let title = $0["title"].element?.text,
                            let link = $0["link"].element?.text,
                            let image = $0["enclosure"].element?.attribute(by: "url")?.text else { return }
                        if counto < wself.maxCollection {
                            wself.titleString.append(title)
                            wself.link.append(link)
                            wself.image.append(image)
                            counto = counto + 1
                        } else {
                            wself.newsTitle.append(title)
                            wself.newsLink.append(link)
                            wself.newsImage.append(image)
                        }
                    }
                    completion?()
                },
                onError: { [weak self] error in
                    self?.showNetWorkErrorDialog()
            })
            .disposed(by: disposeBag)
    }
    
    func getNews() {
        self.newsInfoAcquisitionProcess { [weak self] in
            self?.tableView.reloadData()
            self?.collectionView.reloadData()
        }
    }
    
    func removeDate() {
        self.newsTitle.removeAll()
        self.newsLink.removeAll()
        self.newsImage.removeAll()
        
        self.titleString.removeAll()
        self.link.removeAll()
        self.image.removeAll()
        
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    func showNetWorkErrorDialog() {
        let alert = UIAlertController(title: self.viewModel.textString(.communicationError),
                                      message: self.viewModel.textString(.again),
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: self.viewModel.textString(.reacquire), style: .default) { [unowned self] _ in
            self.getNews()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int { self.newsTitle.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)
        cell.selectionStyle = .none
        (cell as? NewsTableViewCell)?.setupCell(title: self.newsTitle[indexPath.row],
                                                imageUrl: self.newsImage[indexPath.row])
        return cell
    }
}
// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = WebView.presentWebView(self.newsLink[indexPath.row]) else { return }
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
        // cell選択状態解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
// MARK: - UICollectionViewDataSource
extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { self.titleString.count }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = NewsCollectionViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let collectionCell = cell as? NewsCollectionViewCell {
            let newsTitle = self.titleString[indexPath.row]
            let newsImage = self.image[indexPath.row]
            collectionCell.setup(image: newsImage, text: newsTitle)
        }
        return cell
    }
}
// MARK: - UICollectionViewDelegate
extension NewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = WebView.presentWebView(self.link[indexPath.row]) else { return }
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
