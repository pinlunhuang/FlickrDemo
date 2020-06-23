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
    
    @IBOutlet weak var photoResultCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoResultCollection.delegate = self
        photoResultCollection.dataSource = self
    }
    

}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        cell.backgroundColor = .black

        return cell
    }
    
    
}

extension ResultViewController : UICollectionViewDelegateFlowLayout {
    
}

