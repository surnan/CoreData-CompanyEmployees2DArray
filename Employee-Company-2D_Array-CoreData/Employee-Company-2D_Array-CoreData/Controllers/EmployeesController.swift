//
//  EmployeesController.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData


protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class EmployeesController:UITableViewController, CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        print("Employee Added")
        employees.append(employee)
        let indexPath = IndexPath(row: employees.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .right)
    }
    
    var company: Company?
//    var employees = [Employee]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "asdf")
        let employee = employees[indexPath.row]
        
        cell?.textLabel?.text = employee.name
        cell?.backgroundColor = UIColor.teal
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        guard let cellString = employee.name else {return cell!}
        guard let taxId = employee.employeeInformation?.taxId else {return cell!}
    
        cell?.textLabel?.text = "\(cellString)   ---- \(taxId)"
        return cell!
    }
    
    private func setupNavigationBar(){
        navigationItem.title = company?.name
        setupPlusButonInNavBar(selector: #selector(handleAddBarButton))
        setupBackButtonInNavBar()
    }
    
    @objc private func handleAddBarButton(){
        print("ADD ADD ADD")
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.company = company
        createEmployeeController.delegate = self
        let navController = CustomNavigationController(rootViewController: createEmployeeController )
        present(navController, animated: true)
    }
    
    var employees = [Employee]()
    private func fetchEmployees(){
        
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}
        self.employees = companyEmployees
        
        
        
        
        
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        let request = NSFetchRequest<Employee>(entityName: "Employee")
//        do {
//            employees = try context.fetch(request)
//            employees.forEach{print("Employee name: \($0.name ?? "")")}
//        } catch let fetchEmployeesErr {
//            print("Failed to fetch employees \(fetchEmployeesErr)")
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "asdf")
        setupNavigationBar()
        tableView.backgroundColor = UIColor.darkBlue
        fetchEmployees()
    }
}
