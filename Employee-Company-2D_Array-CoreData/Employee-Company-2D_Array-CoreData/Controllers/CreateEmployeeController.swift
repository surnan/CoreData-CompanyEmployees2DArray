//
//  CreateEmployeeController.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit


class CreateEmployeeController: UIViewController {
    
    var delegate: CreateEmployeeControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Enter Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private func setupNavigationBar(){
        navigationItem.title = "Create Employee"
        setupCancelButtonInNavBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
    }
    
    
    @objc private func handleSave(){
        print("save save save")
        guard let name = nameTextField.text else {return}
        let (newEmployee, error) = CoreDataManager.shared.createEmployee(employee: name)

        if let error = error {
            print("Error = \(error)")
        }
        dismiss(animated: true, completion: {[unowned self] in
            self.delegate?.didAddEmployee(employee: newEmployee!)
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkBlue
        setupNavigationBar()
        let blueBackgroundView = setupLightBlueBackgroundView(height: 100)
        [nameLabel, nameTextField].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: blueBackgroundView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: blueBackgroundView.leadingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 75),
            
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: blueBackgroundView.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            ])
    }
}
