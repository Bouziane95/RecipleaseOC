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
    
    var ingredients = [Ingredients]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableViewIngredients: UITableView!
    @IBOutlet weak var txtFieldIngredients: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewIngredients.delegate = self
        tableViewIngredients.dataSource = self
        loadIngredient()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
    }
    
    @IBAction func addIngredient(_ sender: UIButton) {
        addNewIngredient()
    }
    
    
    @IBAction func clearIngredient(_ sender: Any) {
        clearAllIngredients()
    }
    
    func addNewIngredient(){
        let newIngredient = Ingredients(context: context)
        newIngredient.name = txtFieldIngredients.text!
        ingredients.append(newIngredient)
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
            ingredients = try context.fetch(request)
        } catch {
            print("Can't load data \(error.localizedDescription)")
        }
        tableViewIngredients.reloadData()
    }
    
    func clearAllIngredients(){
        ingredients.forEach{context.delete($0)}
        ingredients.removeAll()
        saveIngredient()
        tableViewIngredients.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewIngredients.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let ingredientCell = ingredients[indexPath.row]
        cell.textLabel?.text = ingredientCell.value(forKey: "name") as? String
        cell.textLabel?.font = UIFont(name: "Marker Felt", size: 20)
        cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cell
    }
    
    
    
}

