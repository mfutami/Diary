//
//  DiaryViewController.swift
//  Diary
//
//  Created by futami on 2019/09/02.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit
import JBDatePicker

class DiaryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var diaryView: JBDatePickerView!
    @IBOutlet weak var beaseView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    // 時刻取得
    var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.diary)
        self.diaryView.delegate = self
        self.setupImage()
        self.setupTableView()
    }
    // Navugation Bar
    func setupNavigation(_ setTitle: navigationTitle) {
        // TODO: 前の月に移動した際にタイトルもその月になるようにする
        self.title = setTitle.title
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
}
extension DiaryViewController {
    func setupTableView() {
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = .clear
        self.tableView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setupImage() {
        self.plusButton.tintColor = .lightGray
        
        self.beaseView.layer.borderColor = UIColor.lightGray.cgColor
        self.beaseView.layer.borderWidth = 1
    }
}

// MARK: - JBDatePickerViewDelegate
extension DiaryViewController: JBDatePickerViewDelegate {
    func didSelectDay(_ dayView: JBDatePickerDayView) {
        guard let dayView = dayView.date else { return }
        print("day selected:\(self.dateFormatter.string(from: dayView))")
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.selectionStyle = .none
        return cell
    }
    
    
}

extension DiaryViewController: UITableViewDelegate {
    
}
