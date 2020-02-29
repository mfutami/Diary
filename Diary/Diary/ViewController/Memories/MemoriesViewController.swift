//
//  MemoriesViewController.swift
//  Diary
//
//  Created by futami on 2019/09/05.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit
import AVFoundation

class MemoriesViewController: UIViewController {
    @IBOutlet weak var cameaView: UIView!
    @IBOutlet weak var basePhotoGraphView: UIView!
    @IBOutlet weak var photographButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    private var captureSession = AVCaptureSession()
    private var mainCamera: AVCaptureDevice?
    private var photoOutput = AVCapturePhotoOutput()
    private var cameraPreviewLayer = AVCaptureVideoPreviewLayer()
    
    var viewModel = MemoriesViewModel()
    
    private var change: Bool = false
    private var isChangeCamera: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.memories)
        self.setupCaptureSession()
        self.setupDevice(change: self.isChangeCamera)
        self.setupShutterButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.captureSession.startRunning()
        self.setupPhotoIageView()
        // 起動時は非表示
        self.photoImageView.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.captureSession.stopRunning()
    }
    // Navugation Bar
    func setupNavigation(_ setTitle: navigationTitle) {
        self.title = setTitle.title
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.setNavigationItem()
    }
    
    func setNavigationItem(flash: Bool = false) {
        self.change = flash
        // インカメラ、アウトカメラに切り替え用
        guard let cutBack = UIImage(named: "cutBack") else { return }
        let cutBackButton = UIBarButtonItem(image: cutBack,
                                            style: .plain,
                                            target: self,
                                            action: #selector(self.chengeCamera))
        // フラッシュ切り替え用
        guard let flashImage = self.viewModel.flashImage(flash: flash) else { return }
        let flashButton = UIBarButtonItem(image: flashImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(self.flashChange))
        self.navigationItem.rightBarButtonItems = [flashButton, cutBackButton]
    }
    // タップされた際にアイコン切り替え
    @objc func flashChange() {
        // 前回保存状態がtrue -> false
        // 前回保存状態がfalse -> true
        let change = self.change ? false : true
        self.setNavigationItem(flash: change)
    }
    @objc func chengeCamera() {
        self.captureSession.stopRunning()
        self.captureSession.inputs.forEach { [weak self] input in
            self?.captureSession.removeInput(input)
        }
        self.captureSession.outputs.forEach { [weak self] output in
            self?.captureSession.removeOutput(output)
        }
        self.isChangeCamera = !self.isChangeCamera
        self.setupDevice(change: self.isChangeCamera)
        self.captureSession.startRunning()
    }
    
    // photoImageView
    func setupPhotoIageView() {
        self.photoImageView.layer.cornerRadius = 15
        self.photoImageView.clipsToBounds = true
        self.photoImageView.layer.borderWidth = 2
        self.photoImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    // カメラ画質の設定（高解像度）
    func setupCaptureSession() {
        self.captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    // プロパティ設定
    func setupDevice(change: Bool) {
        let position: AVCaptureDevice.Position = change ? .back : .front
        // TODO: OSによってdevicesの中身が空の為
        let propertySettings = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInDualCamera], mediaType: AVMediaType.video, position: position)
        let media = AVMediaType.video
        
        // TODO: 上記でposition設定している為カメラデバイスの取得はしなくて良いのでは、、、
        
        // AVCaptureDevice.DiscoverySession がinitな為2回目呼び出すとAVCaptureDeviceが取得できない為for文がスルーされてしまう。
        // なので2回目以降は別々で取得する必要がありそう、、リファレンス要確認
        let devices = propertySettings.devices
        for devices in devices {
            if devices.position == position {
                self.mainCamera = devices
            }
            self.setupInputOutput()
        }
    }
    
    // 入出力データ設定
    func setupInputOutput() {
        do {
            guard let mainCameraInput = self.mainCamera else { return }
            // 指定したデバイスを使用するために入力を初期化
            let captureDeviceInput = try AVCaptureDeviceInput(device: mainCameraInput)
            // 指定した入力をセッションに追加
            self.captureSession.addInput(captureDeviceInput)
            // 出力ファイルのフォーマットをJPEGに指定
            self.photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
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
        self.cameaView.layer.insertSublayer(self.cameraPreviewLayer, at: 0)
    }
    
    // shutterButton layout
    func setupShutterButton() {
        self.basePhotoGraphView.layer.borderWidth = 2
        self.basePhotoGraphView.layer.cornerRadius = 40
        self.basePhotoGraphView.layer.borderColor = UIColor.white.cgColor
        
        self.photographButton.layer.cornerRadius = 30
        self.photographButton.backgroundColor = UIColor.white
    }
    
    // MARK: - Action
    @IBAction func shutterButtonAction(_ sender: UIButton) {
        // TODO: メモ_AVCapturePhotoSettingsが2回目以降になると起動しない？的なこと書いてあったためメソッド内で設定したらいけた
        let settings = AVCapturePhotoSettings()
        // フラッシュ設定
        settings.flashMode = .off
        // 手振れ補正
        settings.isAutoRedEyeReductionEnabled = true
        self.photoOutput.capturePhoto(with: settings, delegate: self)
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
        }
    }
}
