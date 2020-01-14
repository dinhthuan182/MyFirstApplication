//
//  UIImageView+Extensions.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/14/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        //check cache for image
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        
        let requestUrl = URL(string: urlString)
        let request = URLRequest(url:requestUrl!)
        let task = URLSession.shared.dataTask(with: request) {
           (data, response, error) in
           if error != nil {
            print(error!)
            return
           }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
            
        }
        task.resume()
    }
}
