//
//  CompaniesController+TableView.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

extension CompaniesController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeesController = EmployeesController()
        employeesController.company = companies[indexPath.row]
        navigationController?.pushViewController(employeesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [unowned self](_, indexPath) in
            let company = self.companies[indexPath.row]
            print("Deleting \(company.name ?? "")")
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            do {
                let context = CoreDataManager.shared.persistentContainer.viewContext
                context.delete(company)
                try context.save()
            }catch let deleteCoreErr {
                print("Error deleting core data from tableView: \(deleteCoreErr)")
            }
        }
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandler)
        editAction.backgroundColor = UIColor.darkBlue
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! CompanyCell
        cell.company = companies[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()  //<--- without this line, it compiles but crashes on run
        view.backgroundColor = UIColor.lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available.  \nPlease enter some..."
        label.numberOfLines = -1
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count != 0 ? 0 : 150
    }
    
    

    
    private func editHandler(action: UITableViewRowAction, indexPath: IndexPath){
        let editCompanyController = CreateCompanyController()
        editCompanyController.company = companies[indexPath.row]
        editCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        present(navController, animated: true)
    }
}
