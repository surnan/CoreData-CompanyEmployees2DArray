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
    var company: Company?
    
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
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let birthdayTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "MM/DD/YYYY"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let employeeTypeSegmentedControl: UISegmentedControl = {
        let type = [EmployeeTypes.Executives.rawValue,
                    EmployeeTypes.Managers.rawValue,
                    EmployeeTypes.Staff.rawValue,
                    EmployeeTypes.Intern.rawValue
                    ]
        
        let sc = UISegmentedControl(items: type)
        sc.selectedSegmentIndex = 2
        sc.backgroundColor = UIColor.lightBlue
        sc.tintColor = UIColor.darkBlue
        
        sc .translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    private func setupNavigationBar(){
        navigationItem.title = "Create Employee"
        setupCancelButtonInNavBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
    }
    
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: "Bad Date", message: "Please enter valid date", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    @objc private func handleSave(){
        guard let name = nameTextField.text else {return}
        guard let company = self.company else {return}
        guard let birthdayText = birthdayTextField.text else {return}
        
        
        
        if birthdayText.isEmpty {
            showError(title: "Empty Birthday", message: "Please Enter Birthday")
            return
        }
        

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            showError(title: "Bad Date", message: "Please enter valid date")
            return
        }
        
        
        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else {return}
        
        let (newEmployee, error) = CoreDataManager.shared.createEmployee(employeeName: name, birthday: birthdayDate, employeeType: employeeType, company: company )
        if let error = error {
            print("Error = \(error)")
        }
        
        guard let currentEmployee = newEmployee else {return}
        dismiss(animated: true, completion: {[unowned self] in
            self.delegate?.didAddEmployee(employee: currentEmployee)
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkBlue
        setupNavigationBar()
        let blueBackgroundView = setupLightBlueBackgroundView(height: 150)
        [nameLabel, nameTextField, birthdayLabel, birthdayTextField, employeeTypeSegmentedControl].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: blueBackgroundView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: blueBackgroundView.leadingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 75),
            
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: blueBackgroundView.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
            birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            birthdayLabel.leadingAnchor.constraint(equalTo: blueBackgroundView.leadingAnchor, constant: 10),
            birthdayLabel.widthAnchor.constraint(equalToConstant: 75),
            
            birthdayTextField.leadingAnchor.constraint(equalTo: birthdayLabel.trailingAnchor, constant: 10),
            birthdayTextField.trailingAnchor.constraint(equalTo: blueBackgroundView.trailingAnchor),
            birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor),
            birthdayTextField.heightAnchor.constraint(equalTo: birthdayLabel.heightAnchor),
            
            
            employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 30),
            employeeTypeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            birthdayLabel.widthAnchor.constraint(equalToConstant: 75),
            ])
    }
}
