//
//  CompaniesController+CreateCompany.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

extension CompaniesController: CreateCompanyControllerDelegate  {
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count-1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .right)
    }
    
    func didEditCompany(company: Company) {
        guard let row = companies.index(of: company) else {return}
        let indexPath = IndexPath(row: row, section: 0)
        companies[row] = company
        tableView.reloadRows(at: [indexPath], with: .left)
    }
}
