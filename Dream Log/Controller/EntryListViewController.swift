//
//  EntryListViewController.swift
//  Dream Log
//
//  Created by Jerry Ding on 2018-05-17.
//  Copyright © 2018 Jerry Ding. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class EntryListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var entries : Results<Entry>?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "EntryTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryCell")
        tableView.rowHeight = 80.0
        
        loadData()
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let entriesCount = entries?.count else { fatalError("entries not found") }
        return entriesCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryTableViewCell
        
        cell.delegate = self

        cell.titleLabel.text = entries![indexPath.row].title

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.timeLabel.text = formatter.string(from: entries![indexPath.row].time!)
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToEntryContent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! EntryContentViewController
        
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("indexPath not found") }
        
        destinationVC.currentEntry = entries![indexPath.row]
        
    }
    
    //MARK: - Add New Entries
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Entry", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Entry Title"
            alertTextField.autocorrectionType = .yes
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            do {
                try self.realm.write {
                    let newEntry = Entry()
                    newEntry.title = textField.text!
                    newEntry.time = Date()
                    newEntry.content = ""
                    self.realm.add(newEntry)
                }
            } catch {
                print("error creating data \(error)")
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadData() {
        
        entries = realm.objects(Entry.self).sorted(byKeyPath: "time", ascending: false)
        
        tableView.reloadData()
        
    }

}

//MARK: - SearchBar Delegate Methods

extension EntryListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        loadData()
        
        entries = entries!.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "time", ascending: false)
        
        tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text! = ""
        
        searchBar.setShowsCancelButton(false, animated: true)
        
        loadData()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
    
}

//MARK: - SwipeTableViewCell Delegate Methods

extension EntryListViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            do {
                try self.realm.write {
                    self.realm.delete(self.entries![indexPath.row])
                }
            } catch {
                print("error deleting data \(error)")
            }
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
