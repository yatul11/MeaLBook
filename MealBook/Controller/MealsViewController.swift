//
//  MealsViewController.swift
//  MealBook
//
//  Created by Ivan on 18.10.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class MealsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var mealManager = MealManager()
    
    var name: String = ""
    var type: String = ""
    var mealID: String = ""
    
    var meals = [Meal]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        mealManager.delegate = self
        tableView.delegate = self
        
        self.navigationItem.title = name
        
        if type == "Cat" {
            mealManager.fetchMeal(catName: name)
        } else {
            mealManager.fetchMeal(areaName: name)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? RecipeViewController
        destination?.id = mealID
    }
    
}


//MARK: - MealManagerDelegate
extension MealsViewController: MealManagerDelegate {
    func didUpdateMeals(_ mealsArray: [Meal]) {
        meals = mealsArray
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }

}

//MARK: - UITableViewDataSource
extension MealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealTableViewCell
        cell.mealLabel.text = meals[indexPath.row].strMeal
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension MealsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mealID = meals[indexPath.row].idMeal
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showRecipe1", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
