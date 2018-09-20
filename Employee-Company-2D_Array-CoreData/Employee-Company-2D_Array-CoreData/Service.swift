//
//  Service.swift
//  IntermediateTraining
//
//  Created by adminon 9/19/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import CoreData
struct Service {

    static let shared = Service()

    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"

    func downloadCompaniesFromServer() {
        print("Attempting to download companies..")
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            print("Finished downloading")
            if let err = err {
                print("Failed to download companies:", err)
                return
            }
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()

            //  WRONG ??! -->   let privateContext = CoreDataManager.shared.persistentContainer.newBackgroundContext()
            //  let test = CoreDataManager.shared.persistentContainer.newBackgroundContext()
            //  test.parent = CoreDataManager.shared.persistentContainer.viewContext

            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)

                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType) //+1
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext     //+2

                jsonCompanies.forEach({ (jsonCompany) in //+3
                    print(jsonCompany.name)
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "MM/dd/yyyy"
                    if  let dateFromString = dateFormat.date(from: jsonCompany.founded){
                        company.founded = dateFromString
                    } else {
                        company.founded = Date()
                    }

                     jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print("  \(jsonEmployee.name)")

                        //UNNecessary to establish another CoreDataManager context or NSManagedObjectContext (.privateQueueConcurrencyType)
                        //Parent-Child relationshiop is also remains intact established from earlier

                        let employee = Employee(context: privateContext)
                        employee.name = jsonEmployee.name
                        employee.type = jsonEmployee.type

                        let employeeInformation = EmployeeInformation(context: privateContext)
                        let birthdayDate = dateFormat.date(from: jsonEmployee.birthday)

                        employee.employeeInformation = employeeInformation
                        employeeInformation.birthday = birthdayDate
                        employee.company = company
                    })
                    do {
                        try privateContext.save()       //-1
                        try privateContext.parent?.save() //-2
                    } catch let privateSaveErr {
                        print("Error saving to private context when downloadingCompaniesFrom Server \(privateSaveErr)")
                    }
                })                                              //-3
            } catch let jsonDecodeErr {
                print("Failed to decode:", jsonDecodeErr)
            }
            //            let string = String(data: data, encoding: .utf8)
            //            print(string)
            }.resume() // please do not forget to make this call
    }
}



//struct Service {
//
//    static let shared = Service()
//
//    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
//
//    func downloadCompaniesFromServer() {
//        print("Attempting to download companies..")
//
//        guard let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { (data, resp, err) in
//
//            print("Finished downloading")
//
//            if let err = err {
//                print("Failed to download companies:", err)
//                return
//            }
//
//            guard let data = data else { return }
//
//            let jsonDecoder = JSONDecoder()
//
//            do {
//                // i'll leave a link in the bottom if you want more details on how JSON Decodable works
//                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
//
//                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//
//                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
//
//                jsonCompanies.forEach({ (jsonCompany) in
//                    print(jsonCompany.name)
//
//                    let company = Company(context: privateContext)
//                    company.name = jsonCompany.name
//
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "MM/dd/yyyy"
//                    let foundedDate = dateFormatter.date(from: jsonCompany.founded)
//
//                    company.founded = foundedDate
//
//                    jsonCompany.employees?.forEach({ (jsonEmployee) in
//                        print("  \(jsonEmployee.name)")
//
//                        let employee = Employee(context: privateContext)
//                        employee.name = jsonEmployee.name
//                        employee.type = jsonEmployee.type
//
//                        let employeeInformation = EmployeeInformation(context: privateContext)
//                        let birthdayDate = dateFormatter.date(from: jsonEmployee.birthday)
//                        employeeInformation.birthday = birthdayDate
//
//                        employee.employeeInformation = employeeInformation
//
//                        employee.company = company
//
//                    })
//
//                    do {
//                        try privateContext.save()
//                        try privateContext.parent?.save()
//
//                    } catch let saveErr {
//                        print("Failed to save companies:", saveErr)
//                    }
//
//                })
//
//            } catch let jsonDecodeErr {
//                print("Failed to decode:", jsonDecodeErr)
//            }
//
//
//            //            let string = String(data: data, encoding: .utf8)
//            //            print(string)
//
//
//            }.resume() // please do not forget to make this call
//
//    }
//
//}


struct JSONCompany: Decodable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
    
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}











