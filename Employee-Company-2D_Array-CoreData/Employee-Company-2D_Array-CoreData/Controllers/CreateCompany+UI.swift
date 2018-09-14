//
//  CreateCompany+PreLoad.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

extension CreateCompanyController {
    func setupUI(){
//        [lightBlueBackgroundView, nameLabel, nameTextField, datePicker, companyImageView].forEach{view.addSubview($0)}
        
        [nameLabel, nameTextField, datePicker, companyImageView].forEach{view.addSubview($0)}
        
        
        let blueBackground = setupLightBlueBackgroundView(height: 400)
        
        
        NSLayoutConstraint.activate([
            companyImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            companyImageView.heightAnchor.constraint(equalToConstant: 100 ),
            companyImageView.widthAnchor.constraint(equalToConstant: 100),
            companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: blueBackground.leadingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 75),
            
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
            datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: blueBackground.bottomAnchor)
            ])
    }
    
    func setupCircularStyle(){
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderWidth = 2
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
