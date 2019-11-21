//
//  StorageManagerRecipe.swift
//  ReciPleaseOCTests
//
//  Created by Bouziane Bey on 21/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//this class is for the interactions with the CoreData
class StorageManagerRecipe {
    
    let persistentContainer: NSPersistentContainer!
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    func saveRecipe(){
        do {
            try mockPersistantContainer.viewContext.save()
        } catch {
            print("create fakes error \(error)")
        }
    }
    
    func remove(objectID: NSManagedObjectID){
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }
    
    func flushData(){
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteRecipe")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs{
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
    }
}
