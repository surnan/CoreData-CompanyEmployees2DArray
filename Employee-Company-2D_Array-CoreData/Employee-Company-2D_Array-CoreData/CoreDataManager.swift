//
//  CoreDataManager.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData


//let persistentContainer = NSPersistentContainer(name: "Workforce")
//persistentContainer.loadPersistentStores { (storeDescription, err) in
//    if let error = err {
//        fatalError("****\nloading of store failed: \(error)")
//    }
//}
//let context = persistentContainer.viewContext


struct CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer = {
        var container = NSPersistentContainer(name: Constants.Workforce.rawValue)
        container.loadPersistentStores(completionHandler: { (storeDescription, err) in
            if let err = err {
                fatalError("Unable to load store: \(err)")
            }
        })
        return container
    }()
}
