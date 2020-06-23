//
//  FavoriteViewController.swift
//  FlickrDemo
//
//  Created by Pinlun on 2020/6/22.
//  Copyright © 2020 pinlun. All rights reserved.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {
    
    var favoritePhotos: [NSManagedObject] = []
    let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    @IBOutlet weak var favoritePhotoCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoritePhotoCollection.delegate = self
        self.favoritePhotoCollection.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "我的最愛"
        getFavoritePhoto()
    }
    
    //MARK: - Core Data Operations
    
    func getFavoritePhoto() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritePhoto")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if !self.favoritePhotos.isEmpty {
                self.favoritePhotos.removeAll()
            }
            for data in result as! [NSManagedObject] {
                self.favoritePhotos.append(data)
            }
            DispatchQueue.main.async {
                self.favoritePhotoCollection.reloadData()
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        if !self.favoritePhotos.isEmpty {
            let photo = favoritePhotos[indexPath.item]
            cell.photoLabel.text = photo.value(forKey: "title") as? String
            cell.imageURL = photo.value(forKey: "imageURL") as? URL
            cell.favorite.isHidden = true
            if photo.value(forKey: "image") != nil {
                let imageData = UIImage(data: photo.value(forKey: "image") as! Data)
                cell.photoImageView.image = imageData
            }
            
            return cell
        } else {
            return cell
        }
    }
}

extension FavoriteViewController : UICollectionViewDelegateFlowLayout {
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
