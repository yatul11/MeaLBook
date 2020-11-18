//
//  CatOrArModel.swift
//  MealBook
//
//  Created by Ivan on 18.10.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

protocol CAManagerDelegate {
    func didUpdateCA(caArray: [CatOrAr])
    func didFailWithError(error: Error)
}

struct CAManager {
    
    let catURL = "https://www.themealdb.com/api/json/v1/1/list.php?c=list"
    
    let areaURL = "https://www.themealdb.com/api/json/v1/1/list.php?a=list"
    
    var delegate: CAManagerDelegate?
    
    func fetchCat() {
        let urlString = "\(catURL)"
        performRequest(urlString: urlString)
    }
    
    func fetchAreas() {
        let urlString = "\(areaURL)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, res, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(catOrArData: safeData)
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(catOrArData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CatOrArData.self, from: catOrArData)
            self.delegate?.didUpdateCA(caArray: decodedData.meals)
        } catch {
            self.delegate?.didFailWithError(error: error)
        }
    }
}
