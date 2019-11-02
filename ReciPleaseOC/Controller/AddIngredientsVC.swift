//
//  AddIngredientsVC.swift
//  ReciPleaseOC
//
//  Created by Bouziane Bey on 29/10/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit
import CoreData

class AddIngredientsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var recipes : [RecipeHits] = []
    var ingredientsArray = [Ingredients]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    
    @IBOutlet weak var tableViewIngredients: UITableView!
    @IBOutlet weak var txtFieldIngredients: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewIngredients.delegate = self
        tableViewIngredients.dataSource = self
        loadIngredient()
        activityIndicator.isHidden = true
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        print(dataFilePath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.isHidden = true
        searchBtn.isHidden = false
    }
    
    
    @IBAction func searchRecipeBtn(_ sender: Any) {
        activityIndicator.isHidden = false
        searchBtn.isHidden = true
        if ingredientsArray.isEmpty{
            searchBtn.isHidden = false
            activityIndicator.isHidden = true
            let alert = UIAlertController(title: "No ingredients", message: "Add some ingredients with the button add !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok Thanks !", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
        ApiModel().fetchResult(ingredientsArray) { (response) in
            if response != nil {
                if response!.hits.count > 0{
                    self.recipes = response!.hits
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showTableRecipe", sender: self)
                    }
                } else {
                    print("Error")
                }
            }
        }
    }
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTableRecipe"{
            let showResultVC = segue.destination as! ShowResultRecipeVC
            showResultVC.recipeParsed = recipes
        }
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        if txtFieldIngredients.text! == "" {
            let alert = UIAlertController(title: "No ingredients", message: "Add an ingredient in the text field next to the button", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok Thanks", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
        addNewIngredient()
    }
}
    
    
    @IBAction func clearIngredient(_ sender: Any) {
        clearAllIngredients()
    }
    
    func addNewIngredient(){
        let newIngredient = Ingredients(context: context)
        newIngredient.name = txtFieldIngredients.text!
        ingredientsArray.append(newIngredient)
        saveIngredient()
        tableViewIngredients.reloadData()
        txtFieldIngredients.text = ""
    }
    
    func saveIngredient(){
        do{
            try context.save()
        } catch {
            print("Can't save \(error.localizedDescription)")
        }
        tableViewIngredients.reloadData()
    }
    
    func loadIngredient(){
        let request : NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        do {
            ingredientsArray = try context.fetch(request)
        } catch {
            print("Can't load data \(error.localizedDescription)")
        }
        tableViewIngredients.reloadData()
    }
    
    func clearAllIngredients(){
        ingredientsArray.forEach{context.delete($0)}
        ingredientsArray.removeAll()
        saveIngredient()
        tableViewIngredients.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewIngredients.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let ingredientCell = ingredientsArray[indexPath.row]
        cell.textLabel?.text = ingredientCell.value(forKey: "name") as? String
        cell.textLabel?.font = UIFont(name: "Marker Felt", size: 20)
        cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            context.delete(ingredientsArray[indexPath.row])
            ingredientsArray.remove(at: indexPath.row)
            tableViewIngredients.deleteRows(at: [indexPath], with: .fade)
            saveIngredient()
            tableViewIngredients.reloadData()
        }
    }
    
    
    
}

