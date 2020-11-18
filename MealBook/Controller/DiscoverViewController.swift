//
//  DiscoverViewController.swift
//  MealBook
//
//  Created by Ivan on 10.10.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var mealManager = MealManager()
    var mealModel: MealModel? = nil
    
    var type: String = ""
    
    var meals = [Meal]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.dataSource = self
        
        mealManager.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func allCategories(_ sender: UIButton) {
        type = "Cat"
        searchBar.endEditing(true)
    }
    
    @IBAction func allAreas(_ sender: UIButton) {
        type = "Ar"
        searchBar.endEditing(true)
    }
    
    @IBAction func randomMeal(_ sender: UIButton) {
        mealManager.fetchMeal()
        searchBar.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? RecipeViewController
        destination?.meal = mealModel
        let destination1 = segue.destination as? CatOrArViewController
        destination1?.type = type
    }
}

//MARK: - UISearchBarDelegate
extension DiscoverViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        
        if let meal = searchBar.text {
            mealManager.fetchMeal(mealName: meal)
        }
        
        searchBar.text = ""
        
    }
    
}

//MARK: - MealManagerDelegate
extension DiscoverViewController: MealManagerDelegate {
    func didUpdateMeals(_ mealsArray: [Meal]) {
        meals = mealsArray
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

//MARK: - UITableViewDataSource
extension DiscoverViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MealTableViewCell
        //cell.textLabel?.text = meals[indexPath.row].strMeal
        
        cell.mealLabel.text = meals[indexPath.row].strMeal
        
        return cell
    }
      
}

//MARK: - UITableViewDelegate
extension DiscoverViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mealModel = MealModel(name: meals[indexPath.row].strMeal, id: meals[indexPath.row].idMeal, category: meals[indexPath.row].strCategory!, area: meals[indexPath.row].strArea!, instructions: meals[indexPath.row].strInstructions!, tags: meals[indexPath.row].strTags, youtube: meals[indexPath.row].strYoutube!, ingridients: [meals[indexPath.row].strIngredient1, meals[indexPath.row].strIngredient2, meals[indexPath.row].strIngredient3, meals[indexPath.row].strIngredient4, meals[indexPath.row].strIngredient5, meals[indexPath.row].strIngredient6, meals[indexPath.row].strIngredient7, meals[indexPath.row].strIngredient8, meals[indexPath.row].strIngredient9, meals[indexPath.row].strIngredient10, meals[indexPath.row].strIngredient11, meals[indexPath.row].strIngredient12, meals[indexPath.row].strIngredient13, meals[indexPath.row].strIngredient14, meals[indexPath.row].strIngredient15, meals[indexPath.row].strIngredient16, meals[indexPath.row].strIngredient17, meals[indexPath.row].strIngredient18, meals[indexPath.row].strIngredient19, meals[indexPath.row].strIngredient20], measures: [meals[indexPath.row].strMeasure1, meals[indexPath.row].strMeasure2, meals[indexPath.row].strMeasure3, meals[indexPath.row].strMeasure4, meals[indexPath.row].strMeasure5, meals[indexPath.row].strMeasure6, meals[indexPath.row].strMeasure7, meals[indexPath.row].strMeasure8, meals[indexPath.row].strMeasure9, meals[indexPath.row].strMeasure10, meals[indexPath.row].strMeasure11, meals[indexPath.row].strMeasure12, meals[indexPath.row].strMeasure13, meals[indexPath.row].strMeasure14, meals[indexPath.row].strMeasure15, meals[indexPath.row].strMeasure16, meals[indexPath.row].strMeasure17, meals[indexPath.row].strMeasure18, meals[indexPath.row].strMeasure19, meals[indexPath.row].strMeasure20], imageLink: meals[indexPath.row].strMealThumb)
        
        
        var NumberOfIngridients = 1
        
        for ingridient in mealModel!.ingridients {
            if ingridient != "" && ingridient != nil {
                NumberOfIngridients += 1
            }
        }
        
        if NumberOfIngridients != 21 {
            for _ in NumberOfIngridients...(mealModel?.ingridients.count)! {
                mealModel!.ingridients.remove(at: NumberOfIngridients - 1)
            }
            for _ in NumberOfIngridients...(mealModel?.measures.count)! {
                mealModel!.measures.remove(at: NumberOfIngridients - 1)
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showRecipe", sender: self)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}


//MARK: - Hide Keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

