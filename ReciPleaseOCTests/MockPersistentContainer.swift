//
//  File.swift
//  ReciPleaseOCTests
//
//  Created by Bouziane Bey on 19/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import Foundation
import CoreData
import UIKit



var mockPersistantContainer: NSPersistentContainer = {
    
    //init a container with a customized managedObjectModel
    let container = NSPersistentContainer(name: "ReciPleaseOC", managedObjectModel: managedObjectModel)
    
    //for use in-memory persistent store, now the container has no more access to the production persistent store
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    description.shouldAddStoreAsynchronously = false
    
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores{ (description, error) in
        precondition(description.type == NSInMemoryStoreType)
        
        if let error = error{
            fatalError("Create in memory coordinator failed \(error)")
        }
    }
    return container
}()

var managedObjectModel: NSManagedObjectModel = {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    return managedObjectModel
}()
