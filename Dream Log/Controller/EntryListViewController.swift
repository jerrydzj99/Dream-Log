//
//  ViewController.swift
//  Dream Log
//
//  Created by Jerry Ding on 2018-05-17.
//  Copyright © 2018 Jerry Ding. All rights reserved.
//

import UIKit
import CoreData

class EntryListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var entryArray = [Entry]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "EntryTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryCell")
        tableView.rowHeight = 50.0
        
        loadData()
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell

        cell.titleLabel.text = entryArray[indexPath.row].title

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.timeLabel.text = formatter.string(from: entryArray[indexPath.row].time!)
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToEntryContent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! EntryContentViewController
        destinationVC.delegate = self
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.currentEntry = entryArray[indexPath.row]
        }
        
    }
    
    //MARK: - Add New Entries
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Entry", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Entry Title"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newEntry = Entry(context: self.context)
            newEntry.title = textField.text!
            newEntry.time = Date()
            newEntry.content = ""
            
            self.entryArray.append(newEntry)
            
            self.saveData()
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("error saving data \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadData() {
        
        let request : NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            entryArray = try context.fetch(request)
        } catch {
            print("error loading data \(error)")
        }
        
        tableView.reloadData()
        
    }

}

//MARK: - Content Delegate Methods

extension EntryListViewController: EntryContentViewControllerDelegate {
    
    func entryContentViewControllerDidDisappear(updatedEntry: Entry) {
        if let indexPath = tableView.indexPathForSelectedRow {
            entryArray[indexPath.row] = updatedEntry
        }
        saveData()
    }
    
}
