//
//  DiaryViewingViewController.swift
//  Diary
//
//  Created by futami on 2020/06/24.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class DiaryViewingViewController: UIViewController {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = DiaryViewingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.setupTableView()
//        self.setupBaseView()
//        self.setuplabel(title: self.viewModel.title, text: self.viewModel.text)
    }
}

private extension DiaryViewingViewController {
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: ViewingTextCell.identifier, bundle: nil),
                                forCellReuseIdentifier: ViewingTextCell.identifier)
        self.tableView.separatorStyle = .none
        self.tableView.layer.cornerRadius = 20
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
//    func setupBaseView() {
//        self.baseView.backgroundColor = .white
//        self.baseView.layer.cornerRadius = 20
//    }
//
//    func setuplabel(title: String?, text: String?) {
//        self.titleLabel.text = title
//        self.titleLabel.font = .boldSystemFont(ofSize: 25)
//        self.titleLabel.textColor = .black
//        self.titleLabel.textAlignment = .left
//
//        self.textLabel.text = text
//
//        self.textLabel.font = .systemFont(ofSize: 20)
//        self.textLabel.textColor = .black
//        self.textLabel.textAlignment = .left
//        self.textLabel.numberOfLines = .zero
//    }
}

extension DiaryViewingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewModel.section[section] {
        case .title(let item):
            return item.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.section.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch self.viewModel.section[indexPath.section] {
        case .title(let item):
            cell = tableView.dequeueReusableCell(withIdentifier: item[indexPath.row].identifier, for: indexPath)
            (cell as? ViewingTextCell)?.setup(text: self.viewModel.text)
        }
        return cell
    }
}

extension DiaryViewingViewController: UITableViewDelegate {
    /// sectionHeadrの高さ設定
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ViewingTitleHeaderView.height
    }
    
    /// sectionHeaderの設定
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let origin = CGPoint(x: 10, y: 10)
        let size = CGSize(width: self.view.frame.width, height: ViewingTitleHeaderView.height)
        let headerView = ViewingTitleHeaderView(frame: CGRect(origin: origin, size: size))
            headerView.setup(title: self.viewModel.title)
        return headerView
    }
}
