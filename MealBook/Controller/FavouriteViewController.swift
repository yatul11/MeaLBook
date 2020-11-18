//
//  FavouriteViewController.swift
//  MealBook
//
//  Created by Ivan on 10.10.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var mealManager = MealManager()
    var mealModel: MealModel? = nil
    var mealID: String = ""
    
    
    var favMealArray: [String] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    var idMealArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.dataSource = self

        favMealArray = []
        idMealArray = []
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Item>.init(entityName: "Item")
        
        do {
            let results = try  context.fetch(fetchRequest)
            for result in results {
                favMealArray.append(result.title!)
                idMealArray.append(result.myMealID!)
            }
        } catch let error {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? RecipeViewController
        destination?.id = mealID
    }
}

//MARK: - UITableViewDataSource
extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favMealArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! MealTableViewCell
        
        cell.mealLabel.text = favMealArray[favMealArray.count - indexPath.row - 1]

        return cell
    }
    
}


//MARK: - UITableViewDelegate
extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mealID = idMealArray[idMealArray.count - indexPath.row - 1]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showRecipe2", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
