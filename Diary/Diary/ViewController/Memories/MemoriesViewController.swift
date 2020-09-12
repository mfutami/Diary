//
//  MemoriesViewController.swift
//  Diary
//
//  Created by futami on 2019/09/05.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class MemoriesViewController: UIViewController {
    @IBOutlet weak var cameaView: UIView!
    @IBOutlet weak var basePhotoGraphView: UIView!
    @IBOutlet weak var photographButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var baseView: UIView!
    private var captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var cameraPreviewLayer = AVCaptureVideoPreviewLayer()
    
    private let viewModel = MemoriesViewModel()
    
    private var change = false
    private var isChangeCamera = true
    
    static var slideView: SlideView?
    
    private var getSlideView: UIView? {
        MemoriesViewController.slideView = SlideView(frame: CGRect(x: self.baseView.bounds.origin.x + 20,
                                                                   y: self.baseView.bounds.origin.y + 10,
                                                                   width: self.baseView.bounds.size.width,
                                                                   height: 40))
        MemoriesViewController.slideView?.delegate = self
        return MemoriesViewController.slideView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.memories)
        self.setupShutterButton()
        self.setupPhotoIageView()
        self.setupSlideView()
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
        self.setupDevice(change: self.isChangeCamera)
        // TODO: 連打でクラッシュする可能性あり
        self.authorization()
        // 起動時は非表示
        self.photoImageView.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeCaptureSession()
    }
}

private extension MemoriesViewController {
    // Navugation Bar
    func setupNavigation(_ setTitle: NavigationTitle) {
        self.navigationController?.navigationItem(title: setTitle.title,
                                                  viewController: self)
        self.setupNavigationRightItem()
    }
    
    func setupNavigationRightItem() {
        let rightSearchBarButtonItem:
            UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "return_icon"),
                                              style: .done,
                                              target: self,
                                              action: #selector(self.chengeCamera))
        self.navigationItem.rightBarButtonItem = rightSearchBarButtonItem
    }
    
    func setupSlideView() {
        guard let slideView = self.getSlideView else { return }
        self.baseView.addSubview(slideView)
    }
    
    func removeCaptureSession() {
        self.captureSession.stopRunning()
        self.captureSession.inputs.forEach { [weak self] input in
            self?.captureSession.removeInput(input)
        }
        self.captureSession.outputs.forEach { [weak self] output in
            self?.captureSession.removeOutput(output)
        }
    }
    
    func authorization() {
        let mediaType = AVMediaType.video
        switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .restricted, .denied:
            self.setErrorDialog()
        case .authorized:
            self.captureSession.startRunning()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType) { [weak self] success in
                if success {
                    self?.captureSession.startRunning()
                } else {
                    DispatchQueue.main.async {
                        self?.setErrorDialog()
                    }
                }
            }
        }
    }
    
    // photoImageView
    func setupPhotoIageView() {
        self.photoImageView.layer.cornerRadius = 15
        self.photoImageView.clipsToBounds = true
        self.photoImageView.layer.borderWidth = 2
        self.photoImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    // プロパティ設定
    func setupDevice(change: Bool) {
        // カメラ画質の設定（高解像度）
        self.captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let position: AVCaptureDevice.Position = change ? .back : .front
        let mainCamera = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                                  for: AVMediaType.video,
                                                  position: position)
        do {
            guard let mainCameraInput = mainCamera else { return }
            // 指定したデバイスを使用するために入力を初期化
            let captureDeviceInput = try AVCaptureDeviceInput(device: mainCameraInput)
            // 指定した入力をセッションに追加
            self.captureSession.addInput(captureDeviceInput)
            // 出力ファイルのフォーマットをJPEGに指定
            self.photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])])
            self.captureSession.addOutput(self.photoOutput)
        } catch {
            // エラー処理なし
        }
        self.setupPreviewLayer()
    }
    
    // カメラのプレビューのを表示するレイヤーの設定
    func setupPreviewLayer() {
        // 指定したAVCaptureSessionでプレビューレイヤを初期化
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        // カメラのキャプチャーを縦横比を維持した状態で表示するように設定
        self.cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // 表示の向きを設定
        self.cameraPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        // viewの座標に合わせる
        self.cameraPreviewLayer.frame = self.view.frame
        // cameraViewのレイヤーの下にcameraPreviewLayerを挿入
        self.cameaView.layer.insertSublayer(self.cameraPreviewLayer, at: .zero)
    }
    
    // shutterButton layout
    func setupShutterButton() {
        self.basePhotoGraphView.layer.borderWidth = 8
        self.basePhotoGraphView.layer.cornerRadius = 40
        self.basePhotoGraphView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.photographButton.layer.cornerRadius = 30
        self.photographButton.backgroundColor = UIColor.white
    }
    
    func openSettingScreen() {
        guard let url = URL(string: self.viewModel.settingUrlString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:])
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func didEnterBackground(_ notification: Notification?) {
        self.captureSession.stopRunning()
    }
    
    @objc func willEnterForeground(_ notification: Notification?) {
        self.authorization()
    }
    
    // MARK: - Action
    @IBAction func shutterButtonAction(_ sender: UIButton) {
        // メモ: AVCapturePhotoSettingsが2回目以降になると起動しない？的なこと書いてあったためメソッド内で設定したらいけた
        let settings = AVCapturePhotoSettings()
        // フラッシュ設定
        settings.flashMode = .off
        // 手振れ補正
        settings.isAutoRedEyeReductionEnabled = true
        self.photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc func chengeCamera() {
        self.removeCaptureSession()
        self.isChangeCamera = !self.isChangeCamera
        self.setupDevice(change: self.isChangeCamera)
        self.captureSession.startRunning()
    }
}
// MARK: - dialog
extension MemoriesViewController {
    func setErrorDialog() {
        let errorDialog = UIAlertController(title: self.viewModel.textString(.error),
                                             message: self.viewModel.textString(.permission),
                                             preferredStyle: .alert)
        let settingButton = UIAlertAction(title: self.viewModel.textString(.setting),
                                          style: .default) { [unowned self] _ in
                                            self.openSettingScreen()
        }
        errorDialog.addAction(settingButton)
        self.present(errorDialog, animated: false)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension MemoriesViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            // Data型をUIImageオブジェクトに変換
            guard let image = UIImage(data: imageData) else { return }
            // imageViewに変更してセットする
            self.photoImageView.isHidden = false
            self.photoImageView.image = image
            // 写真ライブラリに画像を保存
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            DataManagement().addPhotoImage(data: imageData)
        }
    }
}

extension MemoriesViewController: PhotoLibraryDelegate {
    func showPhotoLibrary() {
        let storyboard = UIStoryboard(name: "PhotoLibrary", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else { return }
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
}

class PhotoImageData: Object {
    @objc dynamic var photoImage = Data()
}
