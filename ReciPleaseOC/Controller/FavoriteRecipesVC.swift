//
//  FavoriteRecipesVC.swift
//  ReciPleaseOC
//
//  Created by Bouziane Bey on 04/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit
import CoreData

class FavoriteRecipesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var favoriteRecipeArray = [FavoriteRecipe]()
    var favoriteRecipeSelected : FavoriteRecipe?
    var ingredientArray = [Ingredients]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableViewFavorite: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequestRecipe = NSFetchRequest<FavoriteRecipe>(entityName: "FavoriteRecipe")
        
        do {
            favoriteRecipeArray = try managedContext.fetch(fetchRequestRecipe)
        } catch {
            print("Can't Load \(error.localizedDescription)")
        }
        tableViewFavorite.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewFavorite.delegate = self
        tableViewFavorite.dataSource = self
    }
    
    func saveFavoriteRecipe(){
        do {
            try context.save()
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionNumber : Int = 1
        if favoriteRecipeArray.count > 0 {
            tableViewFavorite.backgroundView = nil
            sectionNumber = 1
        } else {
            let noDataLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableViewFavorite.bounds.size.width, height: self.tableViewFavorite.bounds.size.height))
            noDataLabel.text = "No recipe in the favorite section yet ! You have to add a new favorite recipe with the star button in the recipe details."
            noDataLabel.font = UIFont(name: "Marker Felt", size: 24)
            noDataLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            self.tableViewFavorite.backgroundView = noDataLabel
        }
        return sectionNumber
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return favoriteRecipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteRecipeTableViewCell
        let recipe = favoriteRecipeArray[indexPath.row]
        var ingredientString = ""
        let arrayIngr = Array(recipe.ingredients!)
        for ingredients in arrayIngr as! [Ingredients]{
            ingredientString += "\(ingredients.name!),"
        }
        //ingredientString.removeLast()
        
        let recipeTimeFloat = recipe.recipeTime
        let recipeTimeString = String(format: "%.f", recipeTimeFloat)
        
        cell.favoriteRecipeTitle.text = recipe.recipeName!
        cell.favoriteRecipeIngredients.text = ingredientString
        cell.favoriteRecipeTime.text = recipeTimeString
        
        DispatchQueue.global().async {
            do {
                let url = URL(string: recipe.recipeImage!)
                let imageData = try Data(contentsOf: url!)
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    cell.favoriteRecipeImage.image = image
                }
            } catch {
                print("erreur \(error.localizedDescription)")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favoriteRecipeSelected = favoriteRecipeArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetailFavoriteRecipe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailFavoriteRecipe"{
            let favoriteRecipeVC = segue.destination as! DetailRecipeVC
            favoriteRecipeVC.favoriteRecipe = favoriteRecipeSelected
            favoriteRecipeVC.isFavorite = true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            context.delete(favoriteRecipeArray[indexPath.row])
            favoriteRecipeArray.remove(at: indexPath.row)
            tableViewFavorite.deleteRows(at: [indexPath], with: .automatic)
            saveFavoriteRecipe()
            tableViewFavorite.reloadData()
        }
    }
    
    
    
    
}
