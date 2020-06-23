//
//  ResultViewController.swift
//  FlickrDemo
//
//  Created by Pinlun on 2020/6/23.
//  Copyright © 2020 pinlun. All rights reserved.
//

import UIKit
import CoreData
import JGProgressHUD

class ResultViewController: UIViewController {
    
    var resultPhotos = [Photo]()
    var keyword: String = ""
    var perPage: String = ""
    var page: Int = 1
    let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    var pullRefresh: UIRefreshControl!
    var searchPhotoManager = SearchPhotoManager()
    
    @IBOutlet weak var photoResultCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoResultCollection.delegate = self
        photoResultCollection.dataSource = self
        searchPhotoManager.delegate = self
        
        pullRefresh = UIRefreshControl()
        let colorAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        pullRefresh.attributedTitle = NSAttributedString(string: "重新載入", attributes: colorAttributes)
        self.photoResultCollection.refreshControl = pullRefresh
        pullRefresh.addTarget(self, action: #selector(refreshResult), for: UIControl.Event.valueChanged)
        
        let loadingCellNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        self.photoResultCollection.register(loadingCellNib, forCellWithReuseIdentifier: "loadingReusableView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "搜尋結果: " + keyword
        searchPhotoManager.searchPhoto(keyword: self.keyword, perPage: self.perPage)
    }
    
    @objc func refreshResult() {
        searchPhotoManager.searchPhoto(keyword: self.keyword, perPage: self.perPage)
    }
    
    func retriveMorePhoto() {
        self.page = self.page + 1
        searchPhotoManager.searchPhoto(keyword: self.keyword, perPage: String(Int(self.perPage)! * self.page))
    }
    
    @objc func favoriteTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let favoriteTapped = tapGestureRecognizer.view as! UIImageView
        
        self.saveFavoritePhoto(index: favoriteTapped.tag)
    }
    
    //MARK: - Core Data Operations
    
    func saveFavoritePhoto(index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let photoEntity = NSEntityDescription.entity(forEntityName: "FavoritePhoto", in: managedContext)!
        
        let favoritePhoto = NSManagedObject(entity: photoEntity, insertInto: managedContext)
        favoritePhoto.setValue(self.resultPhotos[index].title, forKey: "title")
        favoritePhoto.setValue(self.resultPhotos[index].imageURL.absoluteString, forKey: "imageURL")
        ImageRetriever.downloadImage(url: self.resultPhotos[index].imageURL) { (image) in
            favoritePhoto.setValue(image?.pngData(), forKey: "image")
        }
        
        do {
            try managedContext.save()
            let hud = JGProgressHUD.init(style: .dark)
            hud.textLabel.text = "已加入最愛"
            hud.indicatorView = nil
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 1.0)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }

}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tapToAddFavorite = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped(tapGestureRecognizer:)))
        
        let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        if !self.resultPhotos.isEmpty {
            let photo = resultPhotos[indexPath.item]
            cell.photoLabel.text = photo.title
            cell.imageURL = photo.imageURL
            cell.favorite.tag = indexPath.item
            cell.favorite.isUserInteractionEnabled = true
            cell.favorite.addGestureRecognizer(tapToAddFavorite)
            
            ImageRetriever.downloadImage(url: cell.imageURL) { (image) in
                if cell.imageURL == photo.imageURL, let image = image  {
                    DispatchQueue.main.async {
                        cell.photoImageView.image = image
                    }
                }
            }
            return cell
        } else {
            return cell
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= -20 {
            retriveMorePhoto()
        }
    }
    
}

extension ResultViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = sectionInsets.left * (itemsPerRow + 1)
        let calculatedWidth = view.frame.width - padding
        let widthPerItem = calculatedWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsets.left
    }
}

extension ResultViewController: SearchPhotoManagerDelegate {
    
    func didUpdateSearchResult(_ weatherManager: SearchPhotoManager, photoResult: PhotoResult) {
        DispatchQueue.main.async {
            if self.resultPhotos.isEmpty == false {
                self.resultPhotos.removeAll()
            }
            self.resultPhotos = photoResult.photos.photo
            
            if self.pullRefresh.isRefreshing {
                self.pullRefresh.endRefreshing()
            }
            self.photoResultCollection.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

