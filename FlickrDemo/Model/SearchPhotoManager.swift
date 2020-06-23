//
//  SearchPhotoManager.swift
//  FlickrDemo
//
//  Created by Pinlun on 2020/6/23.
//  Copyright © 2020 pinlun. All rights reserved.
//

import Foundation

protocol SearchPhotoManagerDelegate {
    func didUpdateSearchResult(_ weatherManager: SearchPhotoManager, photos: PhotoResult)
    func didFailWithError(error: Error)
}

struct SearchPhotoManager {
    let apiURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=03149181ea2445b336b1de6ec28059c1"
    
    var delegate: SearchPhotoManagerDelegate?
    
    func searchPhoto(keyword: String, perPage: String) {
        let url = "\(apiURL)&text=\(keyword)&per_page=\(perPage)&format=json&nojsoncallback=1"
        sendRequest(with: url)
    }
    
    func sendRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let responseData = data {
                    if let photoResult = self.parseJsonData(responseData) {
                        self.delegate?.didUpdateSearchResult(self, photos: photoResult)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJsonData(_ response: Data) -> PhotoResult? {
        let decoder = JSONDecoder()
        do {
            let decodedRespnse = try decoder.decode(PhotoResult.self, from: response)
            return decodedRespnse
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
