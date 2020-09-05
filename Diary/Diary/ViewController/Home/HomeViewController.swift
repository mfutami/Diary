//
//  HomeViewController.swift
//  Diary
//
//  Created by futami on 2019/09/08.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var whetherIcon: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timerBaseView: UIView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var changeIconButton: UIButton!
    
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    private let disposeBag = DisposeBag()
    private let indicator = Indicator()
    
    let weatherLabelFontSize: CGFloat = 30
    let temperatureLabelFontSize: CGFloat = 50
    let detailsLabelFontSize: CGFloat = 15
    let cityLabelFontSize: CGFloat = 20
    
    var viewModel = HomeViewModel()
    
    let prefectures = PrefecturesViewController()
    
    var timerString: String? {
        didSet {
            self.timerLabel.text = self.timerString
        }
    }
    
    var nowDate: String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: now)
    }
    
    var nowTimer: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        let now = Date()
        return dateFormatter.string(from: now)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.home)
        self.setupBaseView(view: self.baseView)
        self.setupBaseView(view: self.timerBaseView)
        self.indicator.indicatorSetup(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard self.viewModel.haveYouAlreadyDone else {
            self.present()
            return
        }
        self.setTimer()
        self.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.whetherIcon.image = nil
    }
}

private extension HomeViewController {
    func setup() {
        self.setupDaysLabel()
        self.setupTimerLabel()
        
        self.setupLabel(label: self.weatherLabel, size: self.weatherLabelFontSize, bold: true)
        self.setupLabel(label: self.temperatureLabel, size: self.temperatureLabelFontSize, bold: true)
        self.setupLabel(label: self.detailsLabel, size: self.detailsLabelFontSize, bold: false)
        self.setupCityLabel()
        self.setupChangeIconButton()
        self.setupWhetherIcon()
        self.getWhether()
    }
    
    // MARK: - Navugation Bar
    
    func setupNavigation(_ setTitle: navigationTitle) {
        self.navigationController?.navigationItem(title: setTitle.title,
                                                  viewController: self)
    }
    
    func setupBaseView(view: UIView) {
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 15
        
        view.layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2
    }
    
    func setupWhetherIcon() {
        self.whetherIcon.contentMode = .scaleAspectFit
    }
    
    func setupLabel(label: UILabel, size: CGFloat, bold font: Bool) {
        label.backgroundColor = .white
        label.text = .empty
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = font ? .boldSystemFont(ofSize: size) : .systemFont(ofSize: size)
        label.numberOfLines = .zero
        label.sizeToFit()
    }
    
    func setupCityLabel() {
        self.cityLabel.backgroundColor = .white
        self.cityLabel.text = .empty
        self.cityLabel.textAlignment = .center
        self.cityLabel.textColor = .black
        self.cityLabel.font = .systemFont(ofSize: self.cityLabelFontSize)
        self.cityLabel.numberOfLines = .zero
        self.cityLabel.sizeToFit()
    }
    
    func setupChangeIconButton() {
        self.changeIconButton.contentMode = .scaleAspectFit
        self.changeIconButton.setImage(UIImage(named: "change"), for: .normal)
        self.changeIconButton.tintColor = .black
        self.changeIconButton.addTarget(self,
                                        action: #selector(self.tapChangeButton),
                                        for: .touchUpInside)
        
        self.changeIconButton.isHidden = true
    }
    
    func setupDaysLabel() {
        self.daysLabel.backgroundColor = .white
        
        self.daysLabel.text = self.nowDate
        self.daysLabel.textColor = .black
        self.daysLabel.textAlignment = .center
        
        self.daysLabel.font = .boldSystemFont(ofSize: 40)
        self.daysLabel.numberOfLines = .zero
        self.daysLabel.sizeToFit()
    }
    
    func setupTimerLabel() {
        self.timerLabel.backgroundColor = .white
        
        self.timerLabel.text = self.nowTimer
        self.timerLabel.textColor = .lightGray
        self.timerLabel.textAlignment = .center
        
        self.timerLabel.font = .boldSystemFont(ofSize: 25)
        self.timerLabel.numberOfLines = .zero
        self.timerLabel.sizeToFit()
    }
    
    func getWhether() {
        self.indicator.start()
        self.viewModel.getWhether()
            .subscribeOn(backgroundScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let wself = self else { return }
                defer { wself.indicator.stop() }
                
                switch wself.viewModel.status {
                case .success:
                    wself.onSuccess()
                default:
                    wself.displayErrorDialog()
                }
        }
        .disposed(by: disposeBag)
    }
    
    func onSuccess() {
        self.setText()
        self.downloadImage()
        self.changeIconButton.isHidden = false
    }
    
    func downloadImage() {
        guard let url = URL(string: self.viewModel.getImageUrl) else { return }
        self.viewModel.getData(from: url) { [weak self] (data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.whetherIcon.image = UIImage(data: data)
            }
        }
    }
    
    func present() {
        HomeViewModel.setPrefectures(set: false)
        let storyboard = UIStoryboard(name: "Prefectures", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController(),
            let prefectures = viewController as? PrefecturesViewController else { return }
        prefectures.delegate = self
        self.present(viewController, animated: false) {
            self.whetherIcon.image = nil
            self.viewModel.deletaCityString()
        }
    }
    
    func displayErrorDialog() {
        let dialog = UIAlertController(title: "天気情報取得失敗",
                                       message: "再取得を実行致します。",
                                       preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.whetherIcon.image = nil
            self?.setup()
        }
        dialog.addAction(okButton)
        self.present(dialog, animated: true)
    }
    
    func setText() {
        self.weatherLabel.text = self.viewModel.getWhetherMain
        self.temperatureLabel.text = self.viewModel.getTemperature
        self.detailsLabel.text = self.viewModel.getDetailsLabelText
        self.cityLabel.text = self.viewModel.getCityName
    }
    

    func setTimer() {
        Timer.scheduledTimer(timeInterval: 1.0,
                             target: self,
                             selector: #selector(self.timer),
                             userInfo: nil,
                             repeats: true)
    }

    @objc func timer() {
        self.timerString = self.nowTimer
    }
    
    @objc func tapChangeButton() {
        self.present()
    }
}

extension HomeViewController: PrefecturesDelegate {
    func startWhether() {
        self.setup()
    }
}

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
}

struct Weather: Codable {
    let main: String
    let icon: String
}
