//
//  ShowResultRecipe.swift
//  ReciPleaseOC
//
//  Created by Bouziane Bey on 01/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit


class ShowResultRecipe: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var recipeParsed : [RecipeHits]?
   
    @IBOutlet weak var tableViewSearch: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSearch.delegate = self
        tableViewSearch.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeParsed!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewSearch.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        let recipe = recipeParsed![indexPath.row].recipe

        //Turning array of string to a string
        let ingredientLinesArray = recipe.ingredientLines
        let ingredientLinesArrayString = ingredientLinesArray.map{String($0)}
        let stringArray = ingredientLinesArrayString.joined(separator: ",")
        //Turning float to a string
        let recipeTimeFloat = recipe.cookingTime
        let recipeTimeString = String(format: "%.f", recipeTimeFloat)
        
        cell.recipeName.text = recipe.recipeName
        cell.ingredientRecipe.text = stringArray
        cell.recipeTime.text = recipeTimeString
        
        DispatchQueue.global().async {
            do {
                let url = URL(string: recipe.imageRecipe)
                let imageData = try Data(contentsOf: url!)
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    cell.recipeImage.image = image
                }
            } catch {
                print("Erreur")
            }
        }

        return cell
        
    }
    
    
    
}
