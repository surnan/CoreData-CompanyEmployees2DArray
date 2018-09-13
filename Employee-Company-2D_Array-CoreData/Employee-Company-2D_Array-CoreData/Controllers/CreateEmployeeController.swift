//
//  CreateEmployeeController.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit


class CreateEmployeeController: UIViewController {
    
    
    private func setupNavigationBar(){
        navigationItem.title = "Create Employee"
        setupCancelButtonInNavBar()
        print("LOADED CANCEL BAR")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkBlue
        setupNavigationBar()
    }
}
