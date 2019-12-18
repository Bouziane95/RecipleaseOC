//
//  RecipeTestCase.swift
//  ReciPleaseOCTests
//
//  Created by Bouziane Bey on 19/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//
//IMPORTANT !!
//uiLocalNotification(time)
//reusableView

import XCTest
import CoreData

class RecipeTestCase: XCTestCase {
    
    var managedObjectContext : NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        self.managedObjectContext = setUpInMemoryManagedObjectContext()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext{
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do{
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Error adding persistent store")
        }
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }
    
    // MARK: - Testing Ingredients in CoreData
    func addIngredient(name: String) -> NSManagedObject{
        let entityIngredient = NSEntityDescription.entity(forEntityName: "Ingredients", in: managedObjectContext)!
        let ingredientLbl = NSManagedObject(entity: entityIngredient, insertInto: managedObjectContext)
        ingredientLbl.setValue(name, forKey: "name")
        return ingredientLbl
    }
    
    func fetchIngredient() -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Ingredients")
        let results = try? managedObjectContext.fetch(request)
        return results as! [NSManagedObject]
    }
    
    //Adding ingredient, then counting ingredient by fetching
    func testGivenEmptyCoreDataWhenUserSaveAnIngredientThenCoreDataIsIncremented(){
        let ingredient = "Onion"
        addIngredient(name: ingredient)
        let results = fetchIngredient()
        print(results)
        XCTAssertEqual(results.count, 1)
    }
    
    // MARK: - Testing Recipes in CoreData
    func addRecipe(recipeName: String) -> NSManagedObject{
        let entityRecipe = NSEntityDescription.entity(forEntityName: "FavoriteRecipe", in: managedObjectContext)!
        let recipeLbl = NSManagedObject(entity: entityRecipe, insertInto: managedObjectContext)
        recipeLbl.setValue(recipeName, forKey: "recipeName")
        return recipeLbl
    }
    
    func fetchRecipe() -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteRecipe")
        let results = try? managedObjectContext.fetch(request)
        return results as! [NSManagedObject]
    }
    
    //Adding recipe, then counting recipe by fetching
    func testGivenEmptyCoreDataWhenUserSaveARecipeThenCoreDataIsIncremented(){
        let recipe = "Recipe1"
        addRecipe(recipeName: recipe)
        let results = fetchRecipe()
        print(results)
        XCTAssertEqual(results.count, 1)
    }
}
