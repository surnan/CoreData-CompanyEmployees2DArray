//
//  ViewController.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor.lightRed
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationItem.title = "Companies"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        
        
        
    }


    @objc private func handleAddCompany(){
        print("xxxx")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        setupNavigationBar()
        
    }
}

