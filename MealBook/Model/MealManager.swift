//
//  MealManager.swift
//  MealBook
//
//  Created by Ivan on 10.10.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

protocol MealManagerDelegate {
    func didUpdateMeals(_ mealsArray: [Meal])
    func didFailWithError(_ error: Error)
}

struct MealManager {
    
    let mealURL = "https://www.themealdb.com/api/json/v1/1/search.php?"
    
    let randomURL = "https://www.themealdb.com/api/json/v1/1/random.php"
    
    let areaURL = "https://www.themealdb.com/api/json/v1/1/filter.php?"
    
    let catURL = "https://www.themealdb.com/api/json/v1/1/filter.php?"
    
    let idURL = "https://www.themealdb.com/api/json/v1/1/lookup.php?"
    
    var delegate: MealManagerDelegate?
    
    func fetchMeal(mealName: String) {
        let urlString = "\(mealURL)s=\(mealName)"
        performRequest(urlString: urlString)
        
    }
    
    func fetchMeal() {
        let urlString = "\(randomURL)"
        performRequest(urlString: urlString)
    }
    
    func fetchMeal(areaName: String) {
        let urlString = "\(areaURL)a=\(areaName)"
        performRequest(urlString: urlString)
    }
    
    func fetchMeal(catName: String) {
        let urlString = "\(catURL)c=\(catName)"
        performRequest(urlString: urlString)
    }
    
    func fetchMeal(id: String) {
        let urlString = "\(idURL)i=\(id)"
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
                    self.parseJSON(mealData: safeData)
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(mealData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MealData.self, from: mealData)
            self.delegate?.didUpdateMeals(decodedData.meals)
        } catch {
            self.delegate?.didFailWithError(error)
        }
    }
}
