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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "asdf")
        let employee = allEmployees[indexPath.section][indexPath.row]
        cell?.textLabel?.text = employee.name
        cell?.backgroundColor = UIColor.teal
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        guard var cellString = employee.name else {return cell!}
        guard let taxId = employee.employeeInformation?.taxId else {return cell!}
        if let birthday = employee.employeeInformation?.birthday{
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateformatter.string(from: birthday)
            cellString = cellString + "  -DOB:- \(dateString)"
        }
        cell?.textLabel?.text = "\(cellString)   ---- \(taxId)"
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    
    
    class IndentedLabel: UILabel {
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            let customRect = UIEdgeInsetsInsetRect(rect, insets)
            super.drawText(in: customRect)
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        var titleString = ""

        switch section {
        case 0: titleString = "Short Names"
        case 1: titleString = "Long Names"
        case 2: titleString = "Really Names"
        default:fatalError("Invalid section - \(section)")
        }
        
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
    
    var employees = [Employee]()
    var shortNameEmployees = [Employee]()
    var longNameEmployees = [Employee]()
    var reallyLongNameEmployees = [Employee]()
    
    var allEmployees = [[Employee]]()
    
    
    
    private func fetchEmployees(){
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}
        
        shortNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count < 6
            }
            return false
        })
        
        longNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count >= 6 && count < 9
            }
            return false
        })
        
        reallyLongNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count >= 9
            }
            return false
        })
        
        allEmployees = [shortNameEmployees, longNameEmployees, reallyLongNameEmployees]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "asdf")
        setupNavigationBar()
        tableView.backgroundColor = UIColor.darkBlue
        fetchEmployees()
    }
}

