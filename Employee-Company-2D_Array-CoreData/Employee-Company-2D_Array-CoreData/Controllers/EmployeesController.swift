//
//  EmployeesController.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit




class EmployeesController:UITableViewController {
    
    
    var company: Company?
    
    
    private func setupNavigationBar(){
        navigationItem.title = company?.name
        setupPlusButonInNavBar(selector: #selector(handleAddBarButton))
        setupBackButtonInNavBar()
    }
    
    
    
    @objc private func handleAddBarButton(){
        print("ADD ADD ADD")
        let createCompanyController = CreateEmployeeController()
        let navController = CustomNavigationController(rootViewController: createCompanyController )
        present(navController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.backgroundColor = UIColor.darkBlue
    }
}
