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
    
    override func setUp() {
        super.setUp()
        sut = StorageManager(container: mockPersistantContainer)
    }
    
    override func tearDown() {
        sut.flushData()
        super.tearDown()
    }
    
    func addIngredient(name: String) -> Ingredients?{
        let obj = NSEntityDescription.insertNewObject(forEntityName: "Ingredients", into: mockPersistantContainer.viewContext)
        obj.setValue(name, forKey: "name")
        sut.saveIngredients()
        return obj as? Ingredients
    }
    
    func testGivenEmptyCoreDataWhenUserSaveAnIngredientThenCoreDataIsIncremented(){
        let ingredient = "Onion"
        let ingredientAdded = addIngredient(name: ingredient)
        XCTAssertNotNil(ingredientAdded)
    }
}
