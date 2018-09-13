//
//  CompaniesController.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData


class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
  
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count-1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .right)
    }
    
    func didEditCompany(company: Company) {
        guard let row = companies.index(of: company) else {return}
        let indexPath = IndexPath(row: row, section: 0)
        companies[row] = company
        tableView.reloadRows(at: [indexPath], with: .left) 
    }
    
    
    var companies = [Company]()
    
    private func setupNavigationBar(){
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
    }
    
    
    
    @objc private func handleReset(){
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchdelete = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchdelete)
            var indexPathsToDelete = [IndexPath]()
            for (index, _) in companies.enumerated() {
                indexPathsToDelete.append(IndexPath(row: index, section: 0))
            }
            
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToDelete, with: .left)
        } catch let coreDataDeleteAllErr {
            print("Error trying to delete all entries from Core Data \(coreDataDeleteAllErr)")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.backgroundColor = UIColor.teal
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        let company = companies[indexPath.row]
        
        if let name = company.name, let founded = company.founded {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateformatter.string(from: founded)
            cell.textLabel?.text = "\(name)   -   \(dateString)"
        } else {
            cell.textLabel?.text = companies[indexPath.row].name
        }
        
        guard let imageFromData = company.imageData, let image = UIImage(data: imageFromData) else {return cell}
        cell.imageView?.image = image
        return cell
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
    
    private func editHandler(action: UITableViewRowAction, indexPath: IndexPath){
        let editCompanyController = CreateCompanyController()
        editCompanyController.company = companies[indexPath.row]
        editCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        present(navController, animated: true)
    }
    
    
    @objc private func handleAddCompany(){
        print("Adding company...")
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        present(navController, animated: true)
    }
    
    
    private func fetchCompanies(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach{print($0.name ?? "")}
            self.companies = companies
            tableView.reloadData()
        } catch let fetchErr {
            print("****\nFailed to fetch companies \(fetchErr)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view.backgroundColor = UIColor.darkBlue
        setupNavigationBar()
        //        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.white
        tableView.tableFooterView = UIView()
        fetchCompanies()
    }
}

