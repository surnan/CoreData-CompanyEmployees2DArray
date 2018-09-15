//
//  CompaniesController.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 admin. All rights reserved.CompanyCell
//

import UIKit
import CoreData


class CompaniesController: UITableViewController{
  
    var companies = [Company]()
    
    private func setupNavigationBar(){
        navigationItem.title = "Companies"
        setupPlusButonInNavBar(selector: #selector(handleAddCompany))
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

    @objc private func handleAddCompany(){
        print("Adding company...")
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        present(navController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellID")
        view.backgroundColor = UIColor.darkBlue
        setupNavigationBar()
        //        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.white
        tableView.tableFooterView = UIView()
        self.companies = CoreDataManager.shared.fetchCompanies().0
    }
}

