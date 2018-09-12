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

//    var companies = [
//        Company(name: "Apple", date: Date()),
//        Company(name: "Google", date: Date()),
//        Company(name: "Facebook", date: Date()),
//    ]

    
    var companies = [Company]()
    
    
    private func setupNavigationBar(){
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.backgroundColor = UIColor.teal
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.textLabel?.text = companies[indexPath.row].name
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

