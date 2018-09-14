//
//  CoreDataManager.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData


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
    
    
    func fetchCompanies() -> ([Company], Error?) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach{print($0.name ?? "")}
            return (companies, nil)
        } catch let fetchErr {
            print("****\nFailed to fetch companies \(fetchErr)")
            return ([], fetchErr)
        }
    }
    
    func createEmployee(employee: String) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext
        let newEmployee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        
        newEmployee.setValue(employee, forKey: "name")
        
        do {
            try context.save()
            return (newEmployee, nil)
        } catch let employeeSaveErr {
            print("Unable to save employee object \(employeeSaveErr)")
            return (nil, employeeSaveErr)
        }
    }
}
