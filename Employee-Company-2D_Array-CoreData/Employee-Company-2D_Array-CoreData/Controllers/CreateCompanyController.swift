//
//  CreateCompanyController.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit


protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
}


class CreateCompanyController:UIViewController {
    
    
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
        
//        [nameLabel].forEach{}
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        view.backgroundColor = UIColor.darkBlue
        setupUI()
        
    }
    
    @objc private func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSave(){
        print("Trying to Save Company")


        dismiss(animated: true, completion: { [unowned self] in
            guard let name = self.nameTextField.text else {return}
            let company = Company(name: name, date: Date())
            self.delegate?.didAddCompany(company: company)
        })
    }
    
}

