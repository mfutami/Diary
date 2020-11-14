//
//  PhotoLibraryViewController.swift
//  Diary
//
//  Created by futami on 2020/06/03.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit

protocol DeletePhotoDelegate: class {
    func selectView(count: Int)
}

class PhotoLibraryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    weak var deletePhotoDelegate: DeletePhotoDelegate?
    
    private var photoImage = [UIImageView]()
    
    private var selectCount: Int?
    
    private var deleteMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        DataManagement.shared.readPhotoImage()
        self.setupCollectionView()
    }
    
    // MARK: - Navugation Bar
    
    func setupNavigation() {
        self.navigationController?.navigationItem(title: "フォトライブラリ",
                                                  viewController: self)
        self.setupNavigationRightItem()
    }
    
    func setupNavigationRightItem() {
        let rightSearchBarButtonItem = UIBarButtonItem(image: UIImage(named: "delete"),
                                                       style: .done,
                                                       target: self,
                                                       action: #selector(self.deleteButton))
        
        let closeButton = UIBarButtonItem(image: UIImage(named: "closeButton"),
                                          style: .done,
                                          target: self,
                                          action: #selector(self.tapCloseButton))
        self.navigationItem.rightBarButtonItems = [closeButton, rightSearchBarButtonItem]
    }
    
    func setupNavigationLeftItem(photoView: PhotoView) {
        self.navigationItem.rightBarButtonItems = nil
        
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                target: photoView,
                                                action: #selector(photoView.tapCloseButton))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func setupNavigationLeftItemWithDelete(count: Int = .zero) {
        self.navigationItem.rightBarButtonItems = nil
        
        let leftBarButtonItem = UIBarButtonItem(title: "キャンセル",
                                                style: .done,
                                                target: self,
                                                action: #selector(self.cancel))
        self.navigationItem.rightBarButtonItem = leftBarButtonItem
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
        self.deleteMode = true
        self.setupNavigationLeftItemWithDelete()
        let deleteView = DeleteView(frame: CGRect(x: self.view.frame.origin.x,
                                                  y: self.view.frame.maxY,
                                                  width: self.view.frame.width,
                                                  height: 60))
        self.view.addSubview(deleteView)
        self.deletePhotoDelegate = deleteView as DeletePhotoDelegate
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            deleteView.setupOrigin(y: self.view.frame.maxY)
        })
    }
    
    @objc func tapCloseButton() {
        self.dismiss(animated: true) {
            guard let slideView = MemoriesViewController.slideView else { return }
            slideView.slideAnimation()
        }
    }
    
    @objc func cancel() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            let deleteView = self.view.subviews.first { $0 is DeleteView }
            (deleteView as? DeleteView)?.setupMaxY()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { deleteView?.removeFromSuperview() }
        })
        self.navigationItem.rightBarButtonItem = nil
        self.setupNavigationRightItem()
    }
}

extension PhotoLibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { DataManagement.shared.photoImageArreData.count }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoImageCollectionViewCell.identifier,
                                                      for: indexPath)
        if let photoImageCollectionViewCell = cell as? PhotoImageCollectionViewCell {
            photoImageCollectionViewCell.setup(data: DataManagement.shared.photoImageArreData[indexPath.row])
            self.photoImage.append(photoImageCollectionViewCell.photoImageView)
        }
        return cell
    }
}

extension PhotoLibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.deleteMode {
            let count = (self.selectCount ?? .zero) + 1
            self.deletePhotoDelegate?.selectView(count: count)
            // TODO: deleteModeをfalseに戻す処理を後日追加
        } else {
            let imageView = PhotoView(frame: self.view.frame)
            imageView.setupImageView(imageView: self.photoImage[indexPath.row])
            imageView.photoDelegate = self
            self.setupNavigationLeftItem(photoView: imageView)
            self.view.addSubview(imageView)
        }
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
