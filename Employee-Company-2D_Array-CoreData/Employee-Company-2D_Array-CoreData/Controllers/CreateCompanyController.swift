//
//  CreateCompanyController.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData


protocol CreateCompanyControllerDelegate: class {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}


class CreateCompanyController:UIViewController {
    
    
    var company: Company?{
        didSet {
            nameTextField.text = company?.name
        }
    }
    
    weak var delegate: CreateCompanyControllerDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Enter Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let lightBlueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    private func setupUI(){
        [lightBlueBackgroundView, nameLabel, nameTextField].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            lightBlueBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: lightBlueBackgroundView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: lightBlueBackgroundView.leadingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 75),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: lightBlueBackgroundView.topAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //navigationItem.title = company == nil ? "Create Company" : "Edit Company"  <--- slow to animate the Nav.Title onto screen
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        view.backgroundColor = UIColor.darkBlue
        setupUI()
    }
    
    @objc private func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func createCompany() {
        print("Trying to Save Company")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(nameTextField.text, forKey: "name")
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        }
        catch let saveErr {
            print("Unable to save new company \(saveErr)")
        }
    }
    
    fileprivate func saveCompanyChanges(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        company?.name = nameTextField.text
        
        guard let newCompany = company else {return}
        do {
            try context.save()
            dismiss(animated: true, completion: {[unowned self] in 
                self.delegate?.didEditCompany(company: newCompany)
            })
        } catch let saveErr{
            print("Problem saving changes to company \(saveErr)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSave(){
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
}
































