//
//  UIImageViewExtension.swift
//  Lc
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromUrl(_ urlString: String) {
        if (urlString.isEmpty) {
            return
        }
        
//        if let imageData = MYCache.getImageFromCache(urlString) {
        if let imageData = MYCache.sharedInstance.imageFromUrl(urlString) {
            self.image = UIImage(data: imageData)
            self.alpha = 1.0
            return
        }
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: {
                (data, response, error) -> Void in
                if let imageData = data as Data? {
                    MYCache.sharedInstance.saveImageWithData(data!, url: (response?.url?.absoluteString)!)
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.image = UIImage(data: imageData)
                        self.alpha = 1.0
                    })
                }
            })
            task.resume()
        }
    }
}

