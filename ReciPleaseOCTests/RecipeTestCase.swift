//
//  RecipeTestCase.swift
//  ReciPleaseOCTests
//
//  Created by Bouziane Bey on 19/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

@testable import ReciPleaseOC
import XCTest
import CoreData

class RecipeTestCase: XCTestCase {
    
    var sut : StorageManager!
    var sutRecipe: StorageManagerRecipe!
    
    override func setUp() {
        super.setUp()
        sut = StorageManager(container: mockPersistantContainer)
        sutRecipe = StorageManagerRecipe(container: mockPersistantContainer)
    }
    
    override func tearDown() {
        sut.flushData()
        sutRecipe.flushData()
        super.tearDown()
    }
    
    // MARK: - Testing Ingredients in CoreData
    func addIngredient(name: String) -> Ingredients?{
        let obj = NSEntityDescription.insertNewObject(forEntityName: "Ingredients", into: mockPersistantContainer.viewContext)
        obj.setValue(name, forKey: "name")
        return obj as? Ingredients
    }
    
    func fetchIngredient() -> [Ingredients]{
        let request : NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        let results = try? mockPersistantContainer.viewContext.fetch(request)
        return results ?? [Ingredients]()
    }
    
    //Method to get the number of data in persistent store
    func numberOfIngredientInPersistentStore() -> Int{
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Ingredients")
        let result = try! mockPersistantContainer.viewContext.fetch(request)
        return result.count
    }
    
    //Adding ingredient
    func testGivenEmptyCoreDataWhenUserSaveAnIngredientThenCoreDataIsIncremented(){
        let ingredient = "Onion"
        let ingredientAdded = addIngredient(name: ingredient)
        sut.saveIngredients()
        XCTAssertNotNil(ingredientAdded)
    }
    
    //Counting ingredient by fetching
    func testGivenOneObjectInCoreDataStoredWhenUserSavedIngredientsThenCoreDataShouldRetrieveIt(){
        let results = fetchIngredient()
        XCTAssertEqual(results.count, 1)
    }
    
    //Remove ingredients and counting
    func testGivenOneObjectInCoreDataWhenUserRemoveOneThenCoreDataDeleteOneIngredient(){
        let ingredients = fetchIngredient()
        let ingredient = ingredients[0]
        
        let numberOfIngredients = ingredients.count
        sut.remove(objectID: ingredient.objectID)
        sut.saveIngredients()
        
        XCTAssertEqual(numberOfIngredientInPersistentStore(), numberOfIngredients-1)
    }
    
    // MARK: - Testing Recipes in CoreData
    
    func addRecipe(recipeName: String) -> FavoriteRecipe?{
        let obj = NSEntityDescription.insertNewObject(forEntityName: "FavoriteRecipe", into: mockPersistantContainer.viewContext)
        obj.setValue(recipeName, forKey: "recipeName")
        return obj as? FavoriteRecipe
    }
    
    func fetchRecipe() -> [FavoriteRecipe]{
        let request : NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        let results = try? mockPersistantContainer.viewContext.fetch(request)
        return results ?? [FavoriteRecipe]()
    }
    
    //Method to get the number of data in persistent store
    func numberOfRecipeInPersistentStore() -> Int{
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteRecipe")
        let result = try! mockPersistantContainer.viewContext.fetch(request)
        return result.count
    }
    
    func testGivenEmptyCoreDataWhenUserSaveARecipeThenCoreDataIsIncremented(){
        let recipe = "Recipe1"
        let recipeAdded = addRecipe(recipeName: recipe)
        sutRecipe.saveRecipe()
        XCTAssertNotNil(recipeAdded)
    }
    
    //Counting recipe by fetching
    func testGivenOneObjectInCoreDataStoredWhenUserSavedRecipeThenCoreDataShouldRetrieveIt(){
        let results = fetchRecipe()
        XCTAssertEqual(results.count, 1)
    }
    
    //Remove recipe and counting
    func testGivenOneRecipeInCoreDataWhenUserRemoveOneThenCoreDataDeleteOneRecipe(){
        let recipes = fetchRecipe()
        let recipe = recipes[0]
        
        let numberOfRecipes = recipes.count
        sutRecipe.remove(objectID: recipe.objectID)
        sutRecipe.saveRecipe()
        
        XCTAssertEqual(numberOfIngredientInPersistentStore(), numberOfRecipes-1)
    }
    
    
    
}
