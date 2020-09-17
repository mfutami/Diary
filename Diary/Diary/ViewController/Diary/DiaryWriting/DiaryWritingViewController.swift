//
//  DiaryWritingViewController.swift
//  Diary
//
//  Created by futami on 2020/06/13.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class DiaryWritingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelBaseView: UIView!
    
    var viewModel = DiaryWritingViewModel()
    var indexPath: Int?
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        self.setupCancel()
        self.setupKeyboardTapped()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableViewHeight.constant = self.tableView.contentSize.height
    }
}

private extension DiaryWritingViewController {
    func setTableView() {
        self.register(identifier: TitleCell.identifier)
        self.register(identifier: TextCell.identifier)
        self.register(identifier: IconCell.identifier)
        
        self.setupLayer(view: self.tableView)
        self.tableView.layer.masksToBounds = false
        
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setupCancel() {
        self.setupLayer(view: self.cancelBaseView)
        self.cancelBaseView.backgroundColor = .white
        
        self.cancelButton.backgroundColor = .clear
        self.cancelButton.setTitle(self.viewModel.textString(.cancel), for: .normal)
        self.cancelButton.setTitleColor(.lightGray, for: .normal)
        self.cancelButton.titleLabel?.font = .systemFont(ofSize: 20)
        self.cancelButton.addTarget(self,
                                    action: #selector(self.tapCancelButton),
                                    for: .touchUpInside)
    }
    
    func setupKeyboardTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func register(identifier: String) {
        self.tableView.register(UINib(nibName: identifier, bundle: nil),
                                forCellReuseIdentifier: identifier)
    }
    
    func setupLayer(view: UIView) {
        view.layer.cornerRadius = 20
        view.layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2
    }
    
    func errorDialog() {
        let error = UIAlertController(title: self.viewModel.textString(.errorTitle),
                                      message: self.viewModel.textString(.nonCompleted),
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: self.viewModel.textString(.ok), style: .cancel)
        error.addAction(okButton)
        self.present(error, animated: false)
    }
    
    @objc func tapCancelButton() {
        self.isEdit = false
        self.indexPath = nil
        self.dismiss(animated: false)
    }
    
    @objc func tapTwitterIcon() {
        guard let title = TitleCell.textString, !title.isEmpty,
            let text = TextCell.textViewString, !text.isEmpty,
            let encodedTitle = ("・\(title)\n\n").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: self.viewModel.urlString + encodedTitle + encodedText) else {
                self.errorDialog()
                return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func tapSaveIcon() {
        guard !(TitleCell.textString ?? .empty).isEmpty,
            !(TextCell.textViewString ?? .empty).isEmpty else {
                self.errorDialog()
                return
        }
        if self.isEdit {
            self.isEdit = false
            DataManagement.shared.editDate(indexPath: self.indexPath)
        } else {
            // 記入したデータを保存
            DataManagement.shared.addDate()
            DataManagement.shared.getdate()
        }
        self.indexPath = nil
        self.dismiss(animated: false)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
}

extension DiaryWritingViewController: UITableViewDataSource {
    /// section内のcellの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewModel.section[section] {
        case .titleHeader(let item):
            return item.count
        case .textHeader(let item):
            return item.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { self.viewModel.section.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch self.viewModel.section[indexPath.section] {
        case .titleHeader(let item):
            cell = self.titleSectionCell(tableView, item: item[indexPath.row], at: indexPath)
        case .textHeader(let item):
            cell = self.textSectionCell(tableView, item: item[indexPath.row], at: indexPath)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    /// TitleSection配下のCellの設定
    func titleSectionCell(_ tableView: UITableView,
                          item: TitleHeader.Title,
                          at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
        switch item {
        case .tetle:
            (cell as? TitleCell)?.setup(title: self.viewModel.title)
        }
        return cell
    }
    
    /// TextSection配下のCellの設定
    func textSectionCell(_ tableView: UITableView,
                         item: TextHeader.Text,
                         at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
        switch item {
        case .text:
            (cell as? TextCell)?.setup(text: self.viewModel.text)
        case .icon:
            if let iconCell = cell as? IconCell {
                iconCell.setupBaseView()
                iconCell.setup("twitter", button: iconCell.twitterIcon)
                iconCell.twitterIcon.addTarget(self,
                                               action: #selector(self.tapTwitterIcon),
                                               for: .touchUpInside)
                iconCell.setup("save", button: iconCell.saveIcon)
                iconCell.saveIcon.addTarget(self,
                                            action: #selector(self.tapSaveIcon),
                                            for: .touchUpInside)
            }
        }
        return cell
    }
}

extension DiaryWritingViewController: UITableViewDelegate {
    /// sectionHeadrの高さ設定
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat { HeaderView.headerHeight }
    
    /// sectionHeaderの設定
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let origin = CGPoint(x: 20, y: .zero)
        let size = CGSize(width: self.view.frame.width, height: HeaderView.headerHeight)
        let headerView = HeaderView(frame: CGRect(origin: origin, size: size))
        switch self.viewModel.section[section] {
        case .titleHeader:
            headerView.setup(text: self.viewModel.textString(.title))
        case .textHeader:
            headerView.setup(text: self.viewModel.textString(.text))
        }
        return headerView
    }
}
