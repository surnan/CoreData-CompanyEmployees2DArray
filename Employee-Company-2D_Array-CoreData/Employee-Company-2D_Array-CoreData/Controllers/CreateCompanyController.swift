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

class CreateCompanyController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var company: Company?{
        didSet {
            nameTextField.text = company?.name
            if let companyImageData = company?.imageData, let image = UIImage(data: companyImageData){
                companyImageView.image = image
                setupCircularStyle()
            }
            guard let currentDate = company?.founded else {return}
            datePicker.date = currentDate
        }
    }
    
    weak var delegate: CreateCompanyControllerDelegate?
    lazy var companyImageView : UIImageView = {
        //       let imageView = UIImageView()
        //        imageView.image = UIImage(named: Constants.select_photo_empty.rawValue)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))  //<---- Added that Line to fix bug
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto))
        imageView.addGestureRecognizer(tapGesture)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
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
    
    let lightBlueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let datePicker: UIDatePicker = {
        var datepicker = UIDatePicker()
        datepicker.datePickerMode = .date
        datepicker.translatesAutoresizingMaskIntoConstraints = false
        return datepicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        view.backgroundColor = UIColor.darkBlue
        setupUI()
    }
    
    @objc func handleSelectPhoto(){
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    @objc private func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func createCompany() {
        print("Trying to Save Company")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(nameTextField.text, forKey: Constants.Name.rawValue)
        company.setValue(datePicker.date, forKey: Constants.Founded.rawValue)
        if let image = companyImageView.image {
            let image2data = UIImageJPEGRepresentation(image, 0.8)
            company.setValue(image2data, forKey: Constants.imageData.rawValue)
        }
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
        company?.founded = datePicker.date
        if let image = companyImageView.image {
            let image2data = UIImageJPEGRepresentation(image, 0.8)
            company?.imageData = image2data
        }
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
            return
        }
        saveCompanyChanges()
    }
}
