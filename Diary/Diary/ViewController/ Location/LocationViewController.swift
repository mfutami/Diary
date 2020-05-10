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
    
    private let dataManagement = DataManagement()
    private var location = CLLocationManager()
    private var region = MKCoordinateRegion()
    // ジオコーディング, 逆ジオコーディング提供インスタンス
    private let geocoder = CLGeocoder()
    // 緯度
    private var latitude: CLLocationDegrees?
    // 経度
    private var longitude: CLLocationDegrees?
    
    var viewModel = LocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.location)
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
        // TODO: cellにデータが存在しない場合viewを表示する予定 - 暫定でここに設定中
        // tableViewが描画されてからじゃないと座標が取得できない為、描画されたタイミングでaddSubViewを行う
        self.view.addSubview(NonDateLoggerLabel(frame: self.tableView.frame))
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
    }
    
    func setupTableView() {
        self.tableView.backgroundColor = self.viewModel.backgroundColor
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
    
    func setupErrorDialog() {
        let dialog = UIAlertController(title: self.viewModel.errorDialogTitle,
                                       message: self.viewModel.errorDialogMessage,
                                       preferredStyle: .alert)
        
        dialog.addAction(UIAlertAction(title: self.viewModel.okButtonTitle, style: .default,
                                       handler: { action in
                                        self.onClickOkButton()
        }))
        dialog.addAction(UIAlertAction(title: self.viewModel.cancelButtonTitle, style: .cancel,
                                       handler: { action in
                                        self.dismiss(animated: true, completion: {
                                            // TODO: キャンセルボタン押下後エラー画面を表示させる
                                        })
        }))
        self.present(dialog, animated: true, completion: nil)
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
                self.setupTableView()
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
    
    func getLocationData() {
        guard let latitude = self.latitude,
            let longitude = self.longitude else { return }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.geocoder.reverseGeocodeLocation(location) { getReverseGeocode, error in
            guard let reverseGeocode = getReverseGeocode?.first,
                let administrativeArea = reverseGeocode.administrativeArea,
                let locality = reverseGeocode.locality,
                let thoroughfare = reverseGeocode.thoroughfare,
                let subThoroughfare = reverseGeocode.subLocality,
                error == nil else {
                    // エラーダイアログを設定
                    return
            }
            let streetAddress = (administrativeArea + locality + thoroughfare + subThoroughfare)
            self.dataManagement.addLocationData(address: streetAddress)
        }
    }
    
    @objc func tapRecordButton(_ sender: UIButton) {
        self.getLocationData()
    }
    
    @objc func didEnterBackground(_ notification: Notification?) {
        
    }
    
    @objc func willEnterForeground(_ notification: Notification?) {
        // TODO: エラーViewあを表示して画面タップ時に設定画面に遷移させるでも良い
        self.requestWhenInUseAuthorization()
    }
    
}
// MARK: - CLLocationManagerDelegate
extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.mapView.userTrackingMode = .followWithHeading
        guard let location = locations.first else { return }
        // 現在位置情報を格納
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}

class LocationData: Object {
    @objc dynamic var streetAddress = ""
}
