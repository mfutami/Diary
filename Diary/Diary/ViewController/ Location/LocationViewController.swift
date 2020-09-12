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
    /// ジオコーディング, 逆ジオコーディング提供インスタンス
    private let geocoder = CLGeocoder()
    /// 現在緯度
    private var currentLatitude: CLLocationDegrees?
    /// 現在経度
    private var currentLongitude: CLLocationDegrees?
    /// 現在位置
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

        // 地点を登録していなかった場合 - 登録VCを表示
        guard self.viewModel.alreadyRegistered else {
            self.showCurrentLocationRegistrationDisplay()
            return
        }
        self.setup()
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
    func setupNavigation(_ setTitle: NavigationTitle) {
        self.navigationController?.navigationItem(title: setTitle.title,
                                                  viewController: self)
        self.setupNavigationRightItem()
    }
    
    func setupNavigationRightItem() {
        let rightSearchBarButtonItem = UIBarButtonItem(image: UIImage(named: "remove"),
                                                       style: .done,
                                                       target: self,
                                                       action: #selector(self.tapNavigationRightBar))
        let rightChangeBarRightItem = UIBarButtonItem(image: UIImage(named: "change"),
                                                      style: .done,
                                                      target: self,
                                                      action: #selector(self.tapNavigationRightChangeBar))
        self.navigationItem.rightBarButtonItems = [rightSearchBarButtonItem, rightChangeBarRightItem]
    }
    
    func setup() {
        self.requestWhenInUseAuthorization()
        self.setupMapView()
        self.setupCompassButton()
        self.setupRecordArea()
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
        self.recordButton.setTitle(self.viewModel.textString(.record), for: .normal)
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
        let size = CGSize(width: 50, height: 50)
        compass.compassVisibility = .visible
        compass.frame = CGRect(origin: .zero, size: size)
        self.mapView.addSubview(compass)
        // デフォルトコンパスを非表示
        self.mapView.showsCompass = false
    }
    
    func setupErrorTextLabel() {
        self.tableView.isHidden = true
        
        self.errorTextLabel.isHidden = false
        self.errorTextLabel.backgroundColor = .white
        self.errorTextLabel.text = self.viewModel.textString(.noneData)
        self.errorTextLabel.textColor = .red
        self.errorTextLabel.textAlignment = .center
        self.errorTextLabel.numberOfLines = .zero
        self.errorTextLabel.font = .systemFont(ofSize: 15)
    }
    
    func setupErrorDialog() {
        let dialog = UIAlertController(title: self.viewModel.textString(.errorTitle),
                                       message: self.viewModel.textString(.errorText),
                                       preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: self.viewModel.textString(.ok), style: .default) { [unowned self] _ in
            self.onClickOkButton()
        }
        let cancelButton = UIAlertAction(title: self.viewModel.textString(.cancel), style: .cancel) { [unowned self] _ in
            self.dismiss(animated: true) {
                // TODO: キャンセルボタン押下後エラー画面を表示させる
            }
        }
        dialog.addAction(okButton)
        dialog.addAction(cancelButton)
        self.present(dialog, animated: true)
    }
    
    func setupRemoveDialog() {
        let removeDialog = UIAlertController(title: self.viewModel.textString(.deleteTitle),
                                             message: self.viewModel.textString(.cannotBeRestored),
                                             preferredStyle: .actionSheet)
        let notRemove = UIAlertAction(title: self.viewModel.textString(.noText), style: .cancel)
        let remove = UIAlertAction(title: self.viewModel.textString(.yesText), style: .default) { [unowned self] _ in
            self.viewModel.deleteRegistrationPoint()
            self.dataManagement.removeLocationData()
            self.tableView.reloadData()
            self.errorDisplayIfThereIsNoInformation()
        }
        removeDialog.addAction(notRemove)
        removeDialog.addAction(remove)
        self.present(removeDialog, animated: false)
    }
    
    func errorDialog() {
        let errorDialog = UIAlertController(title: self.viewModel.textString(.locationNone),
                                            message: self.viewModel.textString(.again),
                                            preferredStyle: .alert)
        let okButton = UIAlertAction(title: self.viewModel.textString(.ok), style: .cancel)
        errorDialog.addAction(okButton)
        self.present(errorDialog, animated: false)
    }
    
    func errorDisplayIfThereIsNoInformation() {
        // 保持データが空の場合 - エラー画面表示
        guard !self.dataManagement.streetAddressData.isEmpty,
            !self.dataManagement.distanceData.isEmpty else {
                self.setupErrorTextLabel()
                return
        }
    }
    
    func showCurrentLocationRegistrationDisplay() {
        self.presentCurrentLocationRegistration()
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
        self.geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { getReverseGeocode, error in
            guard let reverseGeocode = getReverseGeocode?.first, error == nil,
                let administrativeArea = reverseGeocode.administrativeArea, let locality = reverseGeocode.locality,
                let name = reverseGeocode.name else {
                    self.errorDialog()
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
                let currentLatitude = self.currentLatitude, let currentLongitude = self.currentLongitude else{ return }
            let distance = CLLocation(latitude: latitude, longitude: longitude)
                .distance(from: CLLocation(latitude: currentLatitude, longitude: currentLongitude))
            // 四捨五入
            var getFloor = distance.binade
            getFloor.round(.up)
            self.dataManagement.addLocationData(address: self.streetAddress, distance: getFloor.description)
            self.dataManagement.readInformation()
            self.tableView.reloadData()
        }
    }
    
    func presentCurrentLocationRegistration() {
        let storyboard = UIStoryboard(name: "CurrentLocationRegistration", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else { return }
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false)
    }
    
    @objc func tapRecordButton(_ sender: UIButton) {
        self.errorTextLabel.isHidden = true
        self.tableView.isHidden = false
        // 登録地点名表示用に追加（現在登録されている情報を表示）
        var point = [String]()
        // 保持済情報を取得
        point = self.viewModel.registrationPoint ?? [.empty]
        // 登録済情報を追加
        point.append(LocationViewModel.registrationData ?? .empty)
        // 全ての保持済登録情報を保持
        self.viewModel.registrationPoint = point
        
        self.getLocationData {
            self.getDistanceFromCurrentPosition(geocodeAddress: LocationViewModel.registrationData)
            self.tableView.reloadData()
        }
    }
    
    @objc func tapNavigationRightBar() {
        self.setupRemoveDialog()
    }
    
    @objc func tapNavigationRightChangeBar() {
        self.presentCurrentLocationRegistration()
    }
    
    @objc func didEnterBackground(_ notification: Notification?) {
        
    }
    
    @objc func willEnterForeground(_ notification: Notification?) {
        self.requestWhenInUseAuthorization()
    }
}

extension LocationViewController {
    func requestWhenInUseAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                self.location.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                self.location.startUpdatingLocation()
            default:
                self.setupErrorDialog()
            }
        } else {
            self.setupErrorDialog()
        }
    }
}

// MARK: - UITableViewDataSource
extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int { self.dataManagement.streetAddressData.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationDataCell.identifier,
                                                 for: indexPath)
        cell.selectionStyle = .none
        (cell as? LocationDataCell)?.setup(presentLocation: self.dataManagement.streetAddressData[indexPath.row],
                                           distanceString: self.dataManagement.distanceData[indexPath.row],
                                           registrationPoint: self.viewModel.registrationPoint?[indexPath.row] ?? .empty)
        return cell
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 現在位置情報を格納
        self.currentLatitude = locations.first?.coordinate.latitude
        self.currentLongitude = locations.first?.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.setup()
        case .denied:
            self.setupErrorDialog()
        default:
            break
        }
    }
}

// MARK: - LocationData
class LocationData: Object {
    @objc dynamic var streetAddress: String = .empty
    @objc dynamic var distance: String = .empty
}
