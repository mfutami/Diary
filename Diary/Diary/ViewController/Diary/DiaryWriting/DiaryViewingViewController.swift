//
//  DiaryViewingViewController.swift
//  Diary
//
//  Created by futami on 2020/06/24.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class DiaryViewingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBaseView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    var viewModel = DiaryViewingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.setupTableView()
        self.setupCloseButton()
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
    
    func setupCloseButton() {
        self.closeBaseView.backgroundColor = .clear
        self.closeBaseView.layer.cornerRadius = 17.5
        self.closeBaseView.layer.borderWidth = 1
        self.closeBaseView.layer.borderColor = UIColor.white.cgColor
        
        self.closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        self.closeButton.tintColor = .white
        self.closeButton.addTarget(self,
                                   action: #selector(self.tapCloseButton),
                                   for: .touchUpInside)
    }
    
    @objc func tapCloseButton() {
        self.dismiss(animated: false)
    }
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
        cell.selectionStyle = .none
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
