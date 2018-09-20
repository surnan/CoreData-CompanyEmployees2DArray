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

enum EmployeeTypes: String {
    case Executives
    case SeniorManagement  = "Senior Management"
    case Managers
    case Staff
    case Intern
}

enum EmployeeType: String {
    case Executives
    case Executive
    case Managers
    case Staff
    case Intern
    case SeniorManagement  = "Senior Management"
}

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: customRect)
    }
}


class EmployeesController:UITableViewController, CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
        guard let section = employeeTypes.index(of: employee.type!) else {return}   //<- Bryan
        allEmployees[section].append(employee)                          //Added by me to preven crashing
        let row = allEmployees[section].count                                       //<- Bryan
        let insertionIndexPath = IndexPath(row: row - 1, section: section)          //<- Bryan
        tableView.insertRows(at: [insertionIndexPath], with: .right)                //<- Bryan
    }
    
    var company: Company?

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.name
        
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.name ?? "")    \(dateFormatter.string(from: birthday))"
        }

        cell.backgroundColor = UIColor.teal
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    
    
  
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        var titleString = ""
        titleString = employeeTypes[section]  //<---- From Bryan
        
        label.text = titleString
        label.backgroundColor = UIColor.lightBlue
        label.textColor = UIColor.darkBlue
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    private func setupNavigationBar(){
        navigationItem.title = company?.name
        setupPlusButonInNavBar(selector: #selector(handleAddBarButton))
        setupBackButtonInNavBar()
    }
    
    @objc private func handleAddBarButton(){
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.company = company
        createEmployeeController.delegate = self
        let navController = CustomNavigationController(rootViewController: createEmployeeController )
        present(navController, animated: true)
    }
    
    var allEmployees = [[Employee]]()

    var employeeTypes = [
        EmployeeType.Intern.rawValue,
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue,
        ]
    
    
    private func fetchEmployees2() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        allEmployees = []
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(
                companyEmployees.filter { $0.type == employeeType }
            )
        }
    }
    private func fetchEmployees(){
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}
        allEmployees = []
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(
                companyEmployees.filter{$0.type == employeeType}
            )
        }
    }
    
    let cellId = "asdf"
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEmployees()
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        setupNavigationBar()
        
    }
}

