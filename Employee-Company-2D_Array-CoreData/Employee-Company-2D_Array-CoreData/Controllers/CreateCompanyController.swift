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
                companyImageView.layer.cornerRadius = companyImageView.frame.width // 2  <--- comment out the divide by 2 solved bug
                companyImageView.clipsToBounds = true
                companyImageView.layer.borderWidth = 2
                companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
                companyImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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
    
    let datePicker: UIDatePicker = {
        var datepicker = UIDatePicker()
        datepicker.datePickerMode = .date
        datepicker.translatesAutoresizingMaskIntoConstraints = false
        return datepicker
    }()
    
    
    private func setupUI(){
        [lightBlueBackgroundView, nameLabel, nameTextField, datePicker, companyImageView].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
            lightBlueBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 400),
            
            companyImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            companyImageView.heightAnchor.constraint(equalToConstant: 200 ),
            companyImageView.widthAnchor.constraint(equalToConstant: 200),
            companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                           
            nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: lightBlueBackgroundView.leadingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 75),
            
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            
            datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor)
            ])
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            companyImageView.image = editedImage
        } else {
            if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                companyImageView.image = originalImage
            }
        }
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.layer.borderWidth = 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

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
        } else {
            saveCompanyChanges()
        }
    }
}
