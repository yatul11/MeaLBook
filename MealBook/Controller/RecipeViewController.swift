
//
//  RecipeViewController.swift
//  MealBook
//
//  Created by Ivan on 12.10.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import CoreData
import AudioToolbox

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    
    var itemsArray = [Item]()
    var imageManager = ImageManager()
    var mealManager = MealManager()
    var meal: MealModel? = nil
    var myMeal: Meal? = nil
    var id: String = ""
    var ingridientsString: String = ""
    var youtubeID: String = ""
    var heart = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func presentMeal() {
        if let meal = self.meal {
            self.titleLabel.text = meal.name
            self.descriptionLabel.text = "\(meal.area) \(meal.category)"
            self.imageManager.performRequest(urlString: meal.imageLink)
            for index in 0..<meal.ingridients.count {
                if self.meal!.measures[index]! == " " {
                    self.directionsLabel.text!.append("\(self.meal!.ingridients[index]!)\n")
                    
                } else {
                    self.directionsLabel.text!.append("\(self.meal!.ingridients[index]!) - \(self.meal!.measures[index]!)\n")
                }
            }
            self.ingridientsString = self.directionsLabel.text!
            self.youtubeID = meal.youtube.components(separatedBy: ["="]).last ?? ""
            self.playerView.load(withVideoId: self.youtubeID, playerVars: ["playsinline": 1])
            let predicate = NSPredicate(format: "title == %@", meal.name)
            let fetchRequest = NSFetchRequest<Item>.init(entityName: "Item")
            fetchRequest.predicate = predicate
            
            do {
                let results = try  self.context.fetch(fetchRequest)
                for result in results {
                    if result.title == meal.name{
                        self.heart = true
                        self.likeButton.image = UIImage(systemName: "heart.fill")
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        playerView.isHidden = true
        imageManager.delegate = self
        mealManager.delegate = self
        
        directionsLabel.text = ""
        
        if id != "" {
            mealManager.fetchMeal(id: id)
        }
        
        
        DispatchQueue.main.async {
            self.presentMeal()
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func likeBarButton(_ sender: UIBarButtonItem) {
        
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
        
        
        if heart == false {
            sender.image = UIImage(systemName: "heart.fill")
            heart = true
            
            let newItem = Item(context: self.context)
            
            newItem.title = meal!.name
            newItem.myMealID = meal!.id
            
            self.saveItems()
            
        } else {
            
            let predicate = NSPredicate(format: "title == %@", meal!.name)
            let fetchRequest = NSFetchRequest<Item>.init(entityName: "Item")
            fetchRequest.predicate = predicate
            
            do {
                let results = try  context.fetch(fetchRequest)
                for result in results {
                    context.delete(result)
                }
                //print(results)
                self.saveItems()
            } catch let error {
                print(error)
            }
            
            sender.image = UIImage(systemName: "heart")
            heart = false
        }
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            UIView.animate(withDuration: 0.7) {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }
            self.playerView.isHidden = true
            self.directionsLabel.isHidden = false
            self.directionsLabel.text = self.ingridientsString
        case 1:
            UIView.animate(withDuration: 0.7) {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }
            self.playerView.isHidden = true
            self.directionsLabel.isHidden = false
            self.directionsLabel.text = self.meal?.instructions
        case 2:
            UIView.animate(withDuration: 0.7) {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }
            self.playerView.isHidden = false
            self.directionsLabel.text = "\n\n\n\n\n\n\n\n\n\n\n"
            self.directionsLabel.isHidden = true
        default:
            break
        }
    }
    
    
}

//MARK: - MealManagerDelegate
extension RecipeViewController: MealManagerDelegate {
    func didUpdateMeals(_ mealsArray: [Meal]) {
        myMeal = mealsArray[0]
        meal = MealModel(name: myMeal!.strMeal, id: myMeal!.idMeal, category: (myMeal?.strCategory)!, area: (myMeal?.strArea)!, instructions: (myMeal?.strInstructions)!, tags: myMeal?.strTags, youtube: (myMeal?.strYoutube)!, ingridients: [myMeal!.strIngredient1, myMeal!.strIngredient2, myMeal!.strIngredient3, myMeal!.strIngredient4, myMeal!.strIngredient5, myMeal!.strIngredient6, myMeal!.strIngredient7, myMeal!.strIngredient8, myMeal!.strIngredient9, myMeal!.strIngredient10, myMeal!.strIngredient11, myMeal!.strIngredient12, myMeal!.strIngredient13, myMeal!.strIngredient14, myMeal!.strIngredient15, myMeal!.strIngredient16, myMeal!.strIngredient17, myMeal!.strIngredient18, myMeal!.strIngredient19, myMeal!.strIngredient20], measures: [myMeal!.strMeasure1, myMeal!.strMeasure2, myMeal!.strMeasure3, myMeal!.strMeasure4, myMeal!.strMeasure5, myMeal!.strMeasure6, myMeal!.strMeasure7, myMeal!.strMeasure8, myMeal!.strMeasure9, myMeal!.strMeasure10, myMeal!.strMeasure11, myMeal!.strMeasure12, myMeal!.strMeasure13, myMeal!.strMeasure14, myMeal!.strMeasure15, myMeal!.strMeasure16, myMeal!.strMeasure17, myMeal!.strMeasure18, myMeal!.strMeasure19, myMeal!.strMeasure20], imageLink: myMeal!.strMealThumb)
        
        
        var NumberOfIngridients = 1
        
        for ingridient in meal!.ingridients {
            if ingridient != "" && ingridient != nil {
                NumberOfIngridients += 1
            }
        }
        
        if NumberOfIngridients != 21 {
            for _ in NumberOfIngridients...(meal?.ingridients.count)! {
                meal!.ingridients.remove(at: NumberOfIngridients - 1)
            }
            for _ in NumberOfIngridients...(meal?.measures.count)! {
                meal!.measures.remove(at: NumberOfIngridients - 1)
            }
            
        }
        
        DispatchQueue.main.async {
            self.presentMeal()
        }
        
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
}

//MARK: - ImageManagerDelegate
extension RecipeViewController: ImageManagerDelegate {
    func didUpdateImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
}

//MARK: - Scroll Up
extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}


extension RecipeViewController {
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    
}

