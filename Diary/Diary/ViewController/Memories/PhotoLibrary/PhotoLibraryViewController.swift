//
//  PhotoLibraryViewController.swift
//  Diary
//
//  Created by futami on 2020/06/03.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

class PhotoLibraryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    private let dataManagement = DataManagement()
    
    private var photoImage = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.dataManagement.readPhotoImage()
        self.setupCollectionView()
    }
    
    // Navugation Bar
    func setupNavigation() {
        self.navigationController?.navigationItem(title: "フォトライブラリ")
        self.setupNavigationRightItem()
    }
    
    func setupNavigationRightItem() {
        let rightSearchBarButtonItem:
            UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "delete"),
                                              style: .done,
                                              target: self,
                                              action: #selector(self.deleteButton))
        
        let closeButton:
            UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeButton"),
                                              style: .done,
                                              target: self,
                                              action: #selector(self.tapCloseButton))
        self.navigationItem.rightBarButtonItems = [closeButton, rightSearchBarButtonItem]
    }
    
    func setupNavigationLeftItem(photoView: PhotoView) {
        self.navigationItem.rightBarButtonItems = nil
        
        let leftBarButtonItem:
            UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                              target: photoView,
                                              action: #selector(photoView.tapCloseButton))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func setupCollectionView() {
        self.collectionView.register(UINib(nibName: PhotoImageCollectionViewCell.identifier, bundle: nil),
                                     forCellWithReuseIdentifier: PhotoImageCollectionViewCell.identifier)
        self.collectionViewHeight.constant = self.collectionView.contentSize.height
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.collectionView.collectionViewLayout = layout
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    @objc func deleteButton() {
        self.setupRemoveDialog()
    }
    
    @objc func tapCloseButton() {
        self.dismiss(animated: true) {
            guard let slideView = MemoriesViewController.slideView else { return }
            slideView.slideAnimation()
        }
    }
    
    func setupRemoveDialog() {
        let removeDialog = UIAlertController(title: "全削除致します。",
                                             message: "削除した写真は復元することができません。",
                                             preferredStyle: .alert)
        let notRemove = UIAlertAction(title: "いいえ", style: .cancel)
        let remove = UIAlertAction(title: "はい", style: .default) { [weak self] _ in
            self?.dataManagement.removePhotoImage()
            self?.collectionView.reloadData()
        }
        removeDialog.addAction(notRemove)
        removeDialog.addAction(remove)
        self.present(removeDialog, animated: false)
    }
}

extension PhotoLibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(self.dataManagement.photoImageArreData.count)")
        return self.dataManagement.photoImageArreData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoImageCollectionViewCell.identifier, for: indexPath)
        if let photoImageCollectionViewCell = cell as? PhotoImageCollectionViewCell {
            photoImageCollectionViewCell.setup(data: self.dataManagement.photoImageArreData[indexPath.row])
            self.photoImage.append(photoImageCollectionViewCell.photoImageView)
        }
        return cell
    }
}

extension PhotoLibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageView = PhotoView(frame: self.view.frame)
        imageView.setupImageView(imageView: self.photoImage[indexPath.row])
        imageView.photoDelegate = self
        self.setupNavigationLeftItem(photoView: imageView)
        self.view.addSubview(imageView)
    }
}

extension PhotoLibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 20
        let cellSize: CGFloat = self.view.frame.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
}

extension PhotoLibraryViewController: PhotoViewDelegate {
    func removeNavigationLeftItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.setupNavigationRightItem()
    }
}
