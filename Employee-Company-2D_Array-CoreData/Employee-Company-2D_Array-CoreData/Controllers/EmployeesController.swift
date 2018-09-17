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
    case Managers
    case Staff
    case Intern
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
//        var section = 0
//        guard let type = employee.type else {print("UNABLE TO UPDATE TABLE!");return}
//        switch type{
//        case EmployeeTypes.Executives.rawValue: section = 0
//        case EmployeeTypes.Managers.rawValue: section = 1
//        case EmployeeTypes.Staff.rawValue: section = 2
//        default:
//            fatalError("EMPLOYEE TYPE NOT IN ENUM")
//        }
//        allEmployees[section].append(employee)
//        let indexPath = IndexPath(row: allEmployees[section].count - 1, section: section)
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
    
    
    
  
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        var titleString = ""

//        switch section {
//        case 0: titleString = EmployeeTypes.Executives.rawValue
//        case 1: titleString = EmployeeTypes.Managers.rawValue
//        case 2: titleString = EmployeeTypes.Staff.rawValue
//        default:fatalError("Invalid section - \(section)")
//        }
        
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
    
//    var employees = [Employee]()
//    var executives = [Employee]()
//    var managers = [Employee]()
//    var staff = [Employee]()
    var allEmployees = [[Employee]]()
    var employeeTypes = [
                            EmployeeTypes.Intern.rawValue,
                            EmployeeTypes.Executives.rawValue,
                            EmployeeTypes.Managers.rawValue,
                            EmployeeTypes.Staff.rawValue,
                        ]
    
    private func fetchEmployees(){
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}
//        executives = companyEmployees.filter{$0.type == EmployeeTypes.Executives.rawValue}
//        managers = companyEmployees.filter{$0.type == EmployeeTypes.Managers.rawValue}
//        staff = companyEmployees.filter{$0.type == EmployeeTypes.Staff .rawValue}
//        allEmployees = [executives, managers, staff]
        allEmployees = []
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(companyEmployees.filter{$0.type == employeeType})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "asdf")
        setupNavigationBar()
        tableView.backgroundColor = UIColor.darkBlue
        fetchEmployees()
    }
}

