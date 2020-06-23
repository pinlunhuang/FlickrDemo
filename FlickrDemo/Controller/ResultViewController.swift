//
//  ResultViewController.swift
//  FlickrDemo
//
//  Created by Pinlun on 2020/6/23.
//  Copyright © 2020 pinlun. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var resultPhotos = [Photo]()
    var keyword: String = ""
    var perPage: String = ""
    let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    var searchPhotoManager = SearchPhotoManager()
    
    @IBOutlet weak var photoResultCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoResultCollection.delegate = self
        photoResultCollection.dataSource = self
        searchPhotoManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchPhotoManager.searchPhoto(keyword: self.keyword, perPage: self.perPage)
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
        let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)  as! PhotoCell
        let photo = resultPhotos[indexPath.item]
        cell.photoLabel.text = photo.title
        cell.imageURL = photo.imageURL
        
        ImageRetriever.downloadImage(url: cell.imageURL) { (image) in
            if cell.imageURL == photo.imageURL, let image = image  {
                DispatchQueue.main.async {
                    cell.photoImageView.image = image
                }
            }
        }
        return cell
    }
    
    
}

extension ResultViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

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
            self.resultPhotos = photoResult.photos.photo
            self.photoResultCollection.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

