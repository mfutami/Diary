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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.dataManagement.readPhotoImage()
        self.setupCollectionView()
    }
    
    // Navugation Bar
    func setupNavigation() {
        self.title = "フォトライブラリ"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.setupNavigationRightItem()
    }
    
    func setupNavigationRightItem() {
        let rightSearchBarButtonItem:
            UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "delete"),
                                              style: .done,
                                              target: self,
                                              action: #selector(self.deleteButton))
        self.navigationItem.rightBarButtonItem = rightSearchBarButtonItem
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
    
    func setupRemoveDialog() {
        let removeDialog = UIAlertController(title: "全削除致します。",
                                             message: "削除した写真は復元することができません。",
                                             preferredStyle: .alert)
        let notRemove = UIAlertAction(title: "いいえ", style: .cancel)
        let remove = UIAlertAction(title: "はい", style: .default) { [weak self] _ in
            self?.dataManagement.removePhotoImage()
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
        }
        return cell
    }
}

extension PhotoLibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 20
        let cellSize: CGFloat = self.view.frame.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
}
