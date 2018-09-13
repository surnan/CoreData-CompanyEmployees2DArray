//
//  CompanyCell.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

/*
 //        cell.backgroundColor = UIColor.teal
 //        cell.textLabel?.textColor = UIColor.white
 //        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
 //
 //        let company = companies[indexPath.row]
 //
 //        if let name = company.name, let founded = company.founded {
 //            let dateformatter = DateFormatter()
 //            dateformatter.dateFormat = "MM/dd/yyyy"
 //            let dateString = dateformatter.string(from: founded)
 //            cell.textLabel?.text = "\(name)   -   \(dateString)"
 //        } else {
 //            cell.textLabel?.text = companies[indexPath.row].name
 //        }
 //
 //        guard let imageFromData = company.imageData, let image = UIImage(data: imageFromData) else {return cell}
 //        cell.imageView?.image = image
*/


class CompanyCell: UITableViewCell {
    
    
    
    var company: Company? {
        didSet {
            nameFoundedDateLabel.text = company?.name
            if let companyImageData = company?.imageData, let image = UIImage(data: companyImageData){
                companyImageView.image = image
                //                setupCircularStyle()
                
            }
            if let founded = company?.founded {
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "MM/dd/yyyy"
                let dateString = dateformatter.string(from: founded)
                nameFoundedDateLabel.text =  nameFoundedDateLabel.text! + "   -   \(dateString)"
            }
        }
    }
    

    
    let companyImageView: UIImageView = {
       var imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameFoundedDateLabel: UILabel = {
       var label = UILabel()
        label.text = "COMPANY NAME"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [companyImageView, nameFoundedDateLabel].forEach{addSubview($0)}
        backgroundColor = UIColor.teal
        NSLayoutConstraint.activate([
            companyImageView.heightAnchor.constraint(equalToConstant: 40),
            companyImageView.widthAnchor.constraint(equalToConstant: 40),
            companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameFoundedDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameFoundedDateLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8),
            nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor),
            nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor),
            nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
