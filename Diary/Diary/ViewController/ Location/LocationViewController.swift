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

class LocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private var location = CLLocationManager()
    private var region = MKCoordinateRegion()
    
    var viewModel = LocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.location)
        self.initMap()
        self.location.delegate = self
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
    
    func requestWhenInUseAuthorization() {
        self.location.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways:
                break
            case .authorizedWhenInUse:
                self.location.startUpdatingLocation()
            case .denied:
                self.setupErrorDialog()
            default:
                break
            }
        }
    }
    
    func initMap() {
        self.region = self.mapView.region
        self.region.span.latitudeDelta = 0.02
        self.region.span.longitudeDelta = 0.02
        
        self.mapView.setRegion(self.region, animated: true)
        // 現在位置の有効化
        self.mapView.showsUserLocation = true
        // 現在位置設定
        self.mapView.userTrackingMode = .follow
    }
    // Navugation Bar
    func setupNavigation(_ setTitle: navigationTitle) {
        self.title = setTitle.title
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
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
    
    func onClickOkButton() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @objc func didEnterBackground(_ notification: Notification?) {
        
    }
    
    @objc func willEnterForeground(_ notification: Notification?) {
        // TODO: エラーViewあを表示して画面タップ時に設定画面に遷移させるでも良い
        self.requestWhenInUseAuthorization()
    }
    
}
extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mapView.userTrackingMode = .follow
    }
}
