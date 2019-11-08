//
//  DetailRecipeVC.swift
//  ReciPleaseOC
//
//  Created by Bouziane Bey on 02/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DetailRecipeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var tableViewIngredients: UITableView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeName: UILabel!
    
    var isFavorite : Bool?
    var favoriteRecipe : FavoriteRecipe?
    var arrayIngredientsFavorite : [String]?
    var ingredientRecipe: Ingredients?
    var recipeArray: [NSManagedObject] = []
    var recipeFromSearch : RecipeDataModel?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFavorite!{
            let image = UIImage(named: "star-filled")
            favoriteBtn.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "star")
            favoriteBtn.setImage(image, for: .normal)
        }
        getRecipe()
    }
    
    func getRecipe(){
        if let recipeSearched = recipeFromSearch{
            recipeName.text = recipeSearched.recipeName
            let recipeTimeFloat = recipeSearched.cookingTime
            let recipeTimeString = String(format: "%.f", recipeTimeFloat)
            recipeTime.text = recipeTimeString
            DispatchQueue.main.async {
                do {
                    let url = URL(string: self.recipeFromSearch!.imageRecipe)
                    let imageData = try Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        self.recipeImage.image = UIImage(data: imageData)
                    }
                } catch {
                    print("Image Problem")
                }
            }
        } else {
            //Create an array of favorite recipe's ingredient
            var stringIngredientsFav = ""
            var arrayIngr = Array(favoriteRecipe!.ingredients!)
            for ingredients in arrayIngr as! [Ingredients]{
                stringIngredientsFav += "\(ingredients.name!),"
            }
            arrayIngredientsFavorite = stringIngredientsFav.components(separatedBy: ",")
            arrayIngr.removeLast()
            
            //Then load the informations of the favorite recipe
            recipeName.text = favoriteRecipe?.recipeName
            let image = UIImage(named: "star-filled")
            favoriteBtn.setImage(image, for: .normal)
            let favRecipeTimeFloat = favoriteRecipe?.recipeTime
            let favoriteRecipeTimeString = String(format: "%.f", favRecipeTimeFloat!)
            recipeTime.text = favoriteRecipeTimeString
            DispatchQueue.main.async {
                do {
                    let url = URL(string: self.favoriteRecipe!.recipeImage!)
                    let imageData = try Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        self.recipeImage.image = UIImage(data: imageData)
                    }
                } catch{
                    print("Problem with image")
                }
            }
            
        }
    }
    
    
    func deleteRecipe(){
        if let favoriteRecipe = favoriteRecipe{
            context.delete(favoriteRecipe)
            do {
                try context.save()
            } catch {
                print(error)
            }
        } else if let searchRecipe = recipeFromSearch{
            let recipeFetchRequest = NSFetchRequest<FavoriteRecipe>(entityName: "FavoriteRecipe")
            let recipePredicate = NSPredicate(format: "recipeName == %@", searchRecipe.recipeName)
            recipeFetchRequest.predicate = recipePredicate
            do {
                var recipe = try context.fetch(recipeFetchRequest)
                if recipe.count > 1{
                    for recipeIndex in 0...recipe.count - 1{
                        let recipeToDelete = recipe[recipeIndex]
                        context.delete(recipeToDelete)
                    }
                } else if recipe.count > 0 {
                    let recipeToDelete = recipe[0]
                    context.delete(recipeToDelete)
                } else {
                    return
                }
            } catch {
                print(error)
            }
        }
        tableViewIngredients.reloadData()
    }
    
    @IBAction func favBtnPressed(_ sender: UIButton) {
        
        if let recipeSearched = recipeFromSearch{
            
            //Turning array of string to a string
            let ingredientLinesArray = recipeSearched.ingredientLines
            let ingredientLinesArrayString = ingredientLinesArray.map{String($0)}
            let stringArrayIngredients = ingredientLinesArrayString.joined(separator: ",")
            
            if !isFavorite!{
                let image = UIImage(named: "star-filled")
                sender.setImage(image, for: .normal)
                saveRecipe(recipeName: recipeSearched.recipeName, recipeIngredients: stringArrayIngredients, recipeImage: recipeSearched.imageRecipe, recipeTime: recipeSearched.cookingTime)
            } else {
                let image = UIImage(named: "star")
                sender.setImage(image, for: .normal)
                deleteRecipe()
            }
            isFavorite = !isFavorite!
            
        } else if let favoriteRecipe = favoriteRecipe{
            
            if isFavorite!{
                let image = UIImage(named: "star")
                sender.setImage(image, for: .normal)
                deleteRecipe()
                performSegue(withIdentifier: "showBack", sender: self)
            } else {
                let image = UIImage(named: "star-filled")
                sender.setImage(image, for: .normal)
                let ingredientsArray = favoriteRecipe.ingredients!.allObjects as! [Ingredients]
                var stringArrayIngredients : [String] = []
                for ingredients in ingredientsArray{
                    stringArrayIngredients.append(ingredients.name!)
                }
                let stringArrayOfIng = stringArrayIngredients.joined(separator: ",")
                saveRecipe(recipeName: favoriteRecipe.recipeName!, recipeIngredients: stringArrayOfIng, recipeImage: favoriteRecipe.recipeImage!, recipeTime: favoriteRecipe.recipeTime)
            }
            isFavorite = !isFavorite!
        }
        
        
    }
    
    func saveRecipe(recipeName: String, recipeIngredients: String, recipeImage: String, recipeTime: Float){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteRecipe", in: managedContext)!
        let recipe = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let entityIngredients = NSEntityDescription.entity(forEntityName: "Ingredients", in: managedContext)!
        let ingredientsLabel = NSManagedObject(entity: entityIngredients, insertInto: managedContext)
        
        recipe.setValue(recipeName, forKey: "recipeName")
        ingredientsLabel.setValue(recipeIngredients, forKey: "name")
        recipe.setValue(recipeImage, forKey: "recipeImage")
        recipe.setValue(recipeTime, forKey: "recipeTime")
        ingredientsLabel.setValue(recipe, forKey: "recipe")
        
        do {
            try managedContext.save()
            recipeArray.append(recipe)
        } catch {
            print("Erreur, \(error)")
        }
        
    }
    
    // MARK: - UITableViewDelegate and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recipe = recipeFromSearch{
            return recipe.ingredientLines.count
        } else if favoriteRecipe != nil {
            return arrayIngredientsFavorite!.count
        } else {
            return recipeFromSearch!.ingredientLines.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewIngredients.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)
        
        if let recipe = recipeFromSearch{
            cell.textLabel?.font = UIFont(name: "Marker Felt", size: 16)
            cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.textLabel?.text = recipe.ingredientLines[indexPath.row]
        } else {
            cell.textLabel?.font = UIFont(name: "Marker Felt", size: 16)
            cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.textLabel?.text = arrayIngredientsFavorite![indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
