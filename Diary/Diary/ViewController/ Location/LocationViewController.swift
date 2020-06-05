//
//  LocationViewController.swift
//  Diary
//
//  Created by futami on 2019/09/08.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class LocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorTextLabel: UILabel!
    
    private let dataManagement = DataManagement()
    private var location = CLLocationManager()
    private var region = MKCoordinateRegion()
    // ジオコーディング, 逆ジオコーディング提供インスタンス
    private let geocoder = CLGeocoder()
    // 現在緯度
    private var currentLatitude: CLLocationDegrees?
    // 現在経度
    private var currentLongitude: CLLocationDegrees?
    
    private var streetAddress: String?
    
    
    var viewModel = LocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.location)
        self.dataManagement.readInformation()
        self.setupTableView()
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
        
        self.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 登録情報がない場合 - errorView表示
        self.errorDisplayIfThereIsNoInformation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.removeFromSuperview()
    }
}
// MARK: - LocationViewController
private extension LocationViewController {
    // Navugation Bar
    func setupNavigation(_ setTitle: navigationTitle) {
        self.title = setTitle.title
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.setupNavigationRightItem()
    }
    
    func setupNavigationRightItem() {
        let rightSearchBarButtonItem:
            UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "remove"),
                                              style: .done,
                                              target: self,
                                              action: #selector(self.tapNavigationRightBar(_:)))
        self.navigationItem.rightBarButtonItem = rightSearchBarButtonItem
    }
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: LocationDataCell.identifier, bundle: nil),
                                forCellReuseIdentifier: LocationDataCell.identifier)
        self.tableView.backgroundColor = self.viewModel.backgroundColor
        self.tableView.dataSource = self
    }
    
    func setupMapView() {
        self.region = self.mapView.region
        self.region.span.latitudeDelta = 0.02
        self.region.span.longitudeDelta = 0.02
        
        self.mapView.setRegion(self.region, animated: true)
        // 現在位置の有効化
        self.mapView.showsUserLocation = true
        // 現在位置設定
        self.mapView.userTrackingMode = .follow
        // 地図よりデータを優先
        self.mapView.mapType = .standard
        
        self.location.delegate = self
    }
    
    func setupRecordArea() {
        // baseView
        self.baseView.backgroundColor = self.viewModel.backgroundColor
        self.baseView.layer.cornerRadius = 15
        self.baseView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // recordButton - text
        self.recordButton.backgroundColor = self.viewModel.backgroundColor
        self.recordButton.setTitle(self.viewModel.recordButtonTitle, for: .normal)
        self.recordButton.setTitleColor(.lightGray, for: .normal)
        self.recordButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        
        // recordButton - layer
        self.recordButton.layer.shadowOpacity = 0.2
        self.recordButton.layer.shadowColor = UIColor.black.cgColor
        self.recordButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.recordButton.layer.cornerRadius = 5
        
        self.recordButton.addTarget(self,
                                    action: #selector(self.tapRecordButton(_:)),
                                    for: .touchUpInside)
    }
    
    func setupCompassButton() {
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        let size = CGSize(width: 50, height: 50)
        compass.frame = CGRect(origin: .zero, size: size)
        self.mapView.addSubview(compass)
        // デフォルトコンパスを非表示
        self.mapView.showsCompass = false
    }
    
    func setupErrorTextLabel() {
        self.tableView.isHidden = true
        
        self.errorTextLabel.isHidden = false
        self.errorTextLabel.backgroundColor = .white
        self.errorTextLabel.text = "表示する記録データがありません。\n現在位置を記録した場合に記録が表示されます。"
        self.errorTextLabel.textColor = .red
        self.errorTextLabel.textAlignment = .center
        self.errorTextLabel.numberOfLines = .zero
        self.errorTextLabel.font = .systemFont(ofSize: 15)
    }
    
    func setupErrorDialog() {
        let dialog = UIAlertController(title: self.viewModel.errorDialogTitle,
                                       message: self.viewModel.errorDialogMessage,
                                       preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: self.viewModel.okButtonTitle, style: .default) { action in
            self.onClickOkButton()
        }
        let cancelButton = UIAlertAction(title: self.viewModel.cancelButtonTitle, style: .cancel) { action in
            self.dismiss(animated: true) {
                // TODO: キャンセルボタン押下後エラー画面を表示させる
            }
        }
        dialog.addAction(okButton)
        dialog.addAction(cancelButton)
        self.present(dialog, animated: true)
    }
    
    func setupRemoveDialog() {
        let removeDialog = UIAlertController(title: "削除してよろしいですか？",
                                             message: "削除した記録は復元することができません。",
                                             preferredStyle: .alert)
        let notRemove = UIAlertAction(title: "いいえ", style: .cancel)
        let remove = UIAlertAction(title: "はい", style: .default) { [weak self] _ in
            self?.dataManagement.removeLocationData()
            self?.tableView.reloadData()
            self?.errorDisplayIfThereIsNoInformation()
        }
        removeDialog.addAction(notRemove)
        removeDialog.addAction(remove)
        self.present(removeDialog, animated: false)
    }
    
    func errorDisplayIfThereIsNoInformation() {
        // 保持データがからの場合 - エラー画面表示
        guard !self.dataManagement.streetAddressData.isEmpty,
            !self.dataManagement.distanceData.isEmpty else {
                self.setupErrorTextLabel()
                return
        }
    }
    
    func requestWhenInUseAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                self.location.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                self.location.startUpdatingLocation()
                self.setupMapView()
                self.setupCompassButton()
                self.setupRecordArea()
            case .denied:
                self.setupErrorDialog()
            default:
                break
            }
        } else {
            self.setupErrorDialog()
        }
    }
    
    func onClickOkButton() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func getLocationData(closure: (() -> Void)?) {
        guard let latitude = self.currentLatitude,
            let longitude = self.currentLongitude else { return }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.geocoder.reverseGeocodeLocation(location) { getReverseGeocode, error in
            guard let reverseGeocode = getReverseGeocode?.first,
                let administrativeArea = reverseGeocode.administrativeArea,
                let locality = reverseGeocode.locality,
                let name = reverseGeocode.name,
                error == nil else {
                    // エラーダイアログを設定
                    return
            }
            // thoroughfare + subThoroughfare（丁目,番地が左記にて取得できるはずなのだが番地が丁目になることがある為暫定としてnameでまとめて取得する
            // 懸念点: nameは地名を表示させる為、丁目,番地ではなく駅にいたら〜駅と表示されてしまう為注意が必要
            self.streetAddress = (administrativeArea + locality + name)
            closure?()
        }
    }
    
    func getDistanceFromCurrentPosition(geocodeAddress: String?) {
        guard let address = geocodeAddress else { return }
        self.geocoder.geocodeAddressString(address) { placemarks, error in
            guard let latitude = placemarks?.first?.location?.coordinate.latitude,
                let longitude = placemarks?.first?.location?.coordinate.longitude,
                let currentLatitude = self.currentLatitude,
                let currentLongitude = self.currentLongitude else{ return }
            let presentLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
            let registrationPosition = CLLocation(latitude: latitude, longitude: longitude)
            let distance = registrationPosition.distance(from: presentLocation)
            // 四捨五入
            var getFloor = distance.binade
            getFloor.round(.up)
            self.dataManagement.addLocationData(address: self.streetAddress, distance: getFloor.description)
            self.dataManagement.readInformation()
            self.tableView.reloadData()
        }
    }
    
    @objc func tapRecordButton(_ sender: UIButton) {
        self.errorTextLabel.isHidden = true
        self.tableView.isHidden = false
        self.getLocationData() {
            self.getDistanceFromCurrentPosition(geocodeAddress: self.streetAddress)
        }
    }
    
    @objc func tapNavigationRightBar(_ sender: UIButton) {
        self.setupRemoveDialog()
    }
    
    @objc func didEnterBackground(_ notification: Notification?) {
        
    }
    
    @objc func willEnterForeground(_ notification: Notification?) {
        // TODO: エラーViewを表示して画面タップ時に設定画面に遷移させるでも良い
        self.requestWhenInUseAuthorization()
    }
    
}
// MARK: - UITableViewDataSource
extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataManagement.streetAddressData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: LocationDataCell.identifier,
                                             for: indexPath)
        cell.selectionStyle = .none
        if let locationDataCell = cell as? LocationDataCell {
            locationDataCell.setup(presentLocation: self.dataManagement.streetAddressData[indexPath.row],
                                   distanceString: self.dataManagement.distanceData[indexPath.row])
        }
        return cell
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        // 現在位置情報を格納
        self.currentLatitude = location.coordinate.latitude
        self.currentLongitude = location.coordinate.longitude
    }
}

class LocationData: Object {
    @objc dynamic var streetAddress = ""
    @objc dynamic var distance = ""
}
