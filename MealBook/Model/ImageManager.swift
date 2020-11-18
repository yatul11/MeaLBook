//
//  ImageManager.swift
//  MealBook
//
//  Created by Ivan on 20.10.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation
import UIKit

protocol ImageManagerDelegate {
    func didUpdateImage(_ image: UIImage)
}

struct ImageManager {
    
    var delegate: ImageManagerDelegate?
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let downloadImageDataTask = session.dataTask(with: url) { (data, res, error) in
                if let error = error {
                    print("Error downloading image: \(error)")
                } else {
                    if let res = res as? HTTPURLResponse {
                        print("Downloaded meal image with response code \(res.statusCode)")
                        if let imageData = data {
                            
                            if let image = UIImage(data: imageData){
                                self.delegate?.didUpdateImage(image)
                            }
                            
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
                
            }
            downloadImageDataTask.resume()
        }
        
    }
}
