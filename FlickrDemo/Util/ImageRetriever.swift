//
//  ImageRetriever.swift
//  FlickrDemo
//
//  Created by Pinlun on 2020/6/23.
//  Copyright © 2020 pinlun. All rights reserved.
//

import UIKit

struct ImageRetriever {
    static func downloadImage(url: URL, handler: @escaping (UIImage?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                handler(image)
            } else {
                handler(nil)
            }
        }
        task.resume()
    }
}
