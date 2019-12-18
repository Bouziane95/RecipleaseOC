//
//  MultipleIngredientsTestCase.swift
//  ReciPleaseOCTests
//
//  Created by Bouziane Bey on 18/12/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import XCTest
import CoreData

class MultipleIngredientsTestCase: XCTestCase {
    
    var managedObjectContext : NSManagedObjectContext!
    
    override func setUp() {
        managedObjectContext = setUpInMemoryManagedObjectContext()
        
        for i in 0..<10{
            do{
                try addIngredient(name: "RandomIngredients \(i)")
                try addRecipe(recipeName: "RandomRecipes \(i)")
            } catch {
                print("Error init test case")
            }
        }
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
    
    func addIngredient(name: String) throws{
        let entityIngredient = NSEntityDescription.entity(forEntityName: "Ingredients", in: managedObjectContext)!
        let ingredientLbl = NSManagedObject(entity: entityIngredient, insertInto: managedObjectContext)
        ingredientLbl.setValue(name, forKey: "name")
        try managedObjectContext.save()
    }
    
    func addRecipe(recipeName: String) throws{
        let entityRecipe = NSEntityDescription.entity(forEntityName: "FavoriteRecipe", in: managedObjectContext)!
        let recipeLbl = NSManagedObject(entity: entityRecipe, insertInto: managedObjectContext)
        recipeLbl.setValue(recipeName, forKey: "recipeName")
        try managedObjectContext.save()
    }
    
    func testCountIngredientInDatabase(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Ingredients")
        let results = try? managedObjectContext.fetch(request)
        XCTAssertEqual(results!.count, 10)
    }
    
    func testRemoveIngredientInDatabase(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Ingredients")
        var results = try? managedObjectContext.fetch(request)
        results!.removeLast()
        XCTAssertEqual(results!.count, 9)
    }
    
    func testCountRecipeInDatabase(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteRecipe")
        let results = try? managedObjectContext.fetch(request)
        XCTAssertEqual(results!.count, 10)
    }
    
    func testRemoveRecipeInDatabase(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteRecipe")
        var results = try? managedObjectContext.fetch(request)
        results!.removeLast()
        XCTAssertEqual(results!.count, 9)
    }

}
