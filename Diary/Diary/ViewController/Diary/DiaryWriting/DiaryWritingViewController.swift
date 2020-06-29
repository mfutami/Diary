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
    
    private let dataManagement = DataManagement()
    
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
        self.tableView.register(UINib(nibName: TitleCell.identifier, bundle: nil),
                                forCellReuseIdentifier: TitleCell.identifier)
        self.tableView.register(UINib(nibName: TextCell.identifier, bundle: nil),
                                forCellReuseIdentifier: TextCell.identifier)
        self.tableView.register(UINib(nibName: IconCell.identifier, bundle: nil),
                                forCellReuseIdentifier: IconCell.identifier)
        
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        
        self.tableView.layer.cornerRadius = 20
        self.tableView.layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
        self.tableView.layer.shadowColor = UIColor.lightGray.cgColor
        self.tableView.layer.shadowOpacity = 0.5
        self.tableView.layer.shadowRadius = 2
        self.tableView.layer.masksToBounds = false
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setupCancel() {
        self.cancelBaseView.layer.cornerRadius = 15
        self.cancelBaseView.layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
        self.cancelBaseView.layer.shadowColor = UIColor.lightGray.cgColor
        self.cancelBaseView.layer.shadowOpacity = 0.5
        self.cancelBaseView.layer.shadowRadius = 2
        
        self.cancelBaseView.backgroundColor = .white
        
        self.cancelButton.backgroundColor = .clear
        self.cancelButton.setTitle("キャンセル", for: .normal)
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
    
    func errorDialog() {
        let error = UIAlertController(title: "エラー",
                                      message: "入力が完了していません。\n再度ご確認ください。",
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel)
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
        guard let title = TitleCell.textString, !title.isEmpty,
        let text = TextCell.textViewString, !text.isEmpty else {
                self.errorDialog()
                return
        }
        if self.isEdit {
            self.isEdit = false
            self.dataManagement.editDate(indexPath: self.indexPath)
        } else {
            // 記入したデータを保存
            self.dataManagement.addDate()
            self.dataManagement.getdate()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.section.count
    }
    
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
    func titleSectionCell(_ tableView: UITableView, item: TitleHeader.Title, at indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
        switch item {
        case .tetle:
            (cell as? TitleCell)?.setup(title: self.viewModel.title)
        }
        return cell
    }
    
    /// TextSection配下のCellの設定
    func textSectionCell(_ tableView: UITableView, item: TextHeader.Text, at indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HeaderView.headerHeight
    }
    
    /// sectionHeaderの設定
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let origin = CGPoint(x: 20, y: .zero)
        let size = CGSize(width: self.view.frame.width, height: HeaderView.headerHeight)
        let headerView = HeaderView(frame: CGRect(origin: origin, size: size))
        switch self.viewModel.section[section] {
        case .titleHeader:
            headerView.setup(text: "題名")
        case .textHeader:
            headerView.setup(text: "本文")
        }
        return headerView
    }
}
