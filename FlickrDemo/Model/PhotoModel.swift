//
//  PhotoModel.swift
//  FlickrDemo
//
//  Created by Pinlun on 2020/6/23.
//  Copyright © 2020 pinlun. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let farm: Int
    let secret: String
    let id: String
    let server: String
    let title: String
    var imageURL: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
    }
}

struct PhotoDataArray: Codable{
    let photo: [Photo]
}

struct PhotoResult: Codable {
    let photos: PhotoDataArray
}
