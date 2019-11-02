//
//  DetailRecipeVC.swift
//  ReciPleaseOC
//
//  Created by Bouziane Bey on 02/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit

class DetailRecipeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableViewIngredients: UITableView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeName: UILabel!
    
    var recipeResult: RecipeDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipe()
    }
    
    func getRecipe(){
        recipeName.text = recipeResult!.recipeName
        let floatRecipeTime = recipeResult!.cookingTime
        let stringRecipeTime = String(format: "%.f", floatRecipeTime)
        recipeTime.text = stringRecipeTime
        DispatchQueue.main.async {
            do {
                let url = URL(string: self.recipeResult!.imageRecipe)
                let imageData = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.recipeImage.image = UIImage(data: imageData)
                }
            } catch {
                print("Erreur Image")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeResult!.ingredientLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewIngredients.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)
        let recipe = recipeResult?.ingredientLines[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Marker Felt", size: 16)
        cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.textLabel?.text = recipe
        return cell
    }
    
}
