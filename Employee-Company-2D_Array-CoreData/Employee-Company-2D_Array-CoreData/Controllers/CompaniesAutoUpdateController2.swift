//
//  CompaniesAutoUpdateController.swift
//  Employee-Company-2D_Array-CoreData
//
//  Created by admin on 9/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController2:UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultsController: NSFetchedResultsController<Company> = {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
        request.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch let fetchErr {
            print("Problem fetching data with FRC: \(fetchErr)")
        }
        return frc
    }()
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.backgroundColor = UIColor.lightBlue
        label.text = fetchedResultsController.sectionIndexTitles[section]
        return label
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    let cellID = "alksdfksd"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CompanyCell
        let company = fetchedResultsController.object(at: indexPath)
        cell.company = company
        return cell
    }
    
    
    @objc private func handleAdd(){
        print("Adding Gorilla Channel")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = Company(context: context)
        company.name = "Gorilla Channel"
        try? context.save()
    }
    
    
    @objc private func handleDelete(){
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS %@", "G")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let companiesWithG = try? context.fetch(request)
        companiesWithG?.forEach({ (company) in
            context.delete(company)
        })
        try? context.save()
    }
    
    
    private func setupNavigationBar(){
        navigationItem.title = "Company Auto-Updates"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)),
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.darkBlue
        setupNavigationBar()
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)
        fetchedResultsController.fetchedObjects?.forEach({ (company) in
            print(company.name ?? "")
        })
    }
}



