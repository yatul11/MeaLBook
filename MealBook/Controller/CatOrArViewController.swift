//
//  CatOrArViewController.swift
//  MealBook
//
//  Created by Ivan on 18.10.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class CatOrArViewController: UIViewController {
    
    var type: String = ""
    var catOrArManager = CAManager()
    var name: String = ""
    
    var ca = [CatOrAr]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catOrArManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        if type == "Cat" {
            self.navigationItem.title = "Categories"
            catOrArManager.fetchCat()
        } else {
            self.navigationItem.title = "Areas"
            catOrArManager.fetchAreas()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? MealsViewController
        destination?.name = name
        destination?.type = type
    }
}


//MARK: - CAManagerDelegate
extension CatOrArViewController: CAManagerDelegate {
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateCA(caArray: [CatOrAr]) {
        ca = caArray
    }
    
}

//MARK: - UITableViewDataSource
extension CatOrArViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ca.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "caCell", for: indexPath)
        if type == "Cat" {
            cell.textLabel?.text = ca[indexPath.row].strCategory
        } else {
            cell.textLabel?.text = ca[indexPath.row].strArea
        }
        return cell
    }

}


//MARK: - UITableViewDelegate
extension CatOrArViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == "Cat" {
            name = ca[indexPath.row].strCategory ?? ""
        } else {
            name = ca[indexPath.row].strArea ?? ""
        }
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toMealsSegue", sender: self)
    }
}
