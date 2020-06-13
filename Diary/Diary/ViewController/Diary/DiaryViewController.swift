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
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    // 時刻取得
    var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    var colorCode: UIColor {
        return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.diary)
        self.diaryView.delegate = self
        self.setupTableView()
        self.setupBaseView()
        self.setupButton()
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
        // TODO: Cell追加時にNib設定
        self.tableView.register(UINib(nibName: DiaryCell.identifier, bundle: nil),
                                forCellReuseIdentifier: DiaryCell.identifier)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.colorCode
        self.tableView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setupBaseView() {
        self.baseView.backgroundColor = self.colorCode
        // iOS11以降のみ対応
        self.baseView.layer.cornerRadius = 20
        self.baseView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setupButton() {
        self.plusButton.setTitle("＋", for: .normal)
        self.plusButton.setTitleColor(.black, for: .normal)
        self.plusButton.titleLabel?.font = .systemFont(ofSize: 25)
        
        self.removeButton.setImage(UIImage(named: "delete"), for: .normal)
        self.removeButton.imageView?.contentMode = .scaleAspectFit
        self.removeButton.titleLabel?.font = .systemFont(ofSize: 25)
        self.removeButton.tintColor = .black
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
        // TODO: 仮
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: DiaryCell.identifier, for: indexPath)
        cell.selectionStyle = .none
        if let diaryCell = cell as? DiaryCell {
            diaryCell.setup()
        }
        // TODO: ここに年月日ごとに取得した日記履歴を表示
        return cell
    }
    
    
}

extension DiaryViewController: UITableViewDelegate {
    
}
