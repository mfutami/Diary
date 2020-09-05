//
//  DiaryViewController.swift
//  Diary
//
//  Created by futami on 2019/09/02.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit
import JBDatePicker
import RealmSwift

class DiaryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var diaryView: JBDatePickerView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    
    private let dataManagement = DataManagement()
    
    var viewModel = DiaryViewModel()
    
    static var date: String?
    
    static var title = [String]()
    
    static var text = [String]()
    
    var dateToShow: String? {
        guard let date = self.diaryView.delegate else { return nil }
        return self.viewModel.dateFormatter.string(from: date.dateToShow)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.diary)
        self.diaryView.delegate = self
        self.setupTableView()
        self.setupBaseView()
        self.setupButton()
        // 現在日時を保持
        DiaryViewController.date = self.dateToShow
        self.dataManagement.getdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableViewHeight.constant = self.tableView.contentSize.height
    }
}
extension DiaryViewController {
    func setupTableView() {
        self.tableView.register(UINib(nibName: DiaryCell.identifier, bundle: nil),
                                forCellReuseIdentifier: DiaryCell.identifier)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.viewModel.colorCode
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    // Navugation Bar
    func setupNavigation(_ setTitle: navigationTitle) {
        self.navigationController?.navigationItem(title: setTitle.title,
                                                  viewController: self)
    }
    
    func setupBaseView() {
        self.baseView.backgroundColor = self.viewModel.colorCode
        // iOS11以降のみ対応
        self.baseView.layer.cornerRadius = 20
        self.baseView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setupButton() {
        self.plusButton.setTitle("＋", for: .normal)
        self.plusButton.setTitleColor(.black, for: .normal)
        self.plusButton.titleLabel?.font = .systemFont(ofSize: 25)
        self.plusButton.addTarget(self,
                                  action: #selector(self.tapPlusButton),
                                  for: .touchUpInside)
    }
    
    func editOrBrowseDialog(title: String, text: String, indexPath: Int) {
        let alert = UIAlertController(title: .empty,
                                      message: "以下の操作を選択してください",
                                      preferredStyle: .alert)
        // 閲覧ボタン
        let browseButton = UIAlertAction(title: "閲覧", style: .default) { [weak self] _ in
            let storyboard = UIStoryboard(name: "DiaryViewing", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController(),
                let diaryViewing = viewController as? DiaryViewingViewController else { return }
            diaryViewing.viewModel = DiaryViewingViewModel(title: title, text: text)
            self?.present(viewController, animated: false)
        }
        // 編集ボタン
        let editButton = UIAlertAction(title: "編集", style: .default) { [weak self] _ in
            let storyboard = UIStoryboard(name: "DiaryWriting", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController(),
                let diaryWriting = viewController as? DiaryWritingViewController else { return }
            diaryWriting.indexPath = indexPath
            diaryWriting.isEdit = true
            diaryWriting.viewModel = DiaryWritingViewModel(title: title, text: text)
            viewController.modalPresentationStyle = .fullScreen
            self?.present(viewController, animated: true)
        }
        // 削除ボタン
        let deleteButton = UIAlertAction(title: "削除", style: .default) { [weak self] _ in
            self?.dataManagement.removeDate(indexPath: indexPath)
            self?.tableView.reloadData()
        }
        // キャンセルボタン
        let cancelButton = UIAlertAction(title: "戻る", style: .cancel)
        alert.addAction(browseButton)
        alert.addAction(editButton)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: false)
    }
    
    @objc func tapPlusButton() {
        let storyboard = UIStoryboard(name: "DiaryWriting", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else { return }
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
}

// MARK: - JBDatePickerViewDelegate
extension DiaryViewController: JBDatePickerViewDelegate {
    func didSelectDay(_ dayView: JBDatePickerDayView) {
        guard let dayView = dayView.date else { return }
        print("day selected:\(self.viewModel.dateFormatter.string(from: dayView))")
        // 選択した日時を保持
        DiaryViewController.date = self.viewModel.dateFormatter.string(from: dayView)
        self.dataManagement.getdate()
        self.tableView.reloadData()
    }
    // 今日以外の選択中のボタンの色
    var colorForSelectionCircleForOtherDate: UIColor { return .lightGray }
    // 曜日欄の色をblack
    var colorForWeekDaysViewBackground: UIColor { return .lightGray }
    // 日にちのサイズ
    var fontForDayLabel: JBFont { return JBFont(name: "ChalkboardSE-Light", size: .small) }
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DiaryViewController.title.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier, for: indexPath)
        cell.selectionStyle = .none
        if let diaryCell = cell as? DiaryCell {
            diaryCell.setup(title: DiaryViewController.title[indexPath.row])
        }
        return cell
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.editOrBrowseDialog(title: DiaryViewController.title[indexPath.row],
                                text: DiaryViewController.text[indexPath.row],
                                indexPath: indexPath.row)
    }
}

class DiaryDate: Object {
    @objc dynamic var date: String = .empty
    let list = List<TitleDiary>()
}

class TitleDiary: Object {
    @objc dynamic var title: String = .empty
    @objc dynamic var text: String = .empty
}
