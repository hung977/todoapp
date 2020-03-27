//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by admin on 11/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: SwipeTableViewController {

var realm = try! Realm()

var categories: Results<Category>?

override func viewDidLoad() {
    super.viewDidLoad()
    loadCategories()
    tableView.rowHeight = 80.0
}

//MARK: - Table View DataSource Methods

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories?.count ?? 1
}


override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"

    
    return cell
}

 //MARK: - Table View Delegate Methods

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
}
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = categories?[indexPath.row]
    }
}


//MARK: - Add new Category

@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
        //What will happen once the users clicks the Add Item button on our UIAlert
        
        if let str = textField.text {
            let newCategory = Category()
            newCategory.name = str
            self.save(category: newCategory)
        }
    }
    alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Create new category"
        textField = alertTextField
    }
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
   }


//MARK: - Data Manipulation Methods

func save(category: Category) {
    do {
        try realm.write {
            realm.add(category)
        }
        
    } catch {
        print("Error saving context \(error)")
    }
    tableView.reloadData()
}

func loadCategories() {
    categories = realm.objects(Category.self)
    tableView.reloadData()
}

//MARK: - Deleta datamodel form Swipe
override func updateModel(at indexPath: IndexPath) {
    do {
        try self.realm.write {
            if let currentCategory = self.categories?[indexPath.row]{
            self.realm.delete(currentCategory)
        }
    }
    } catch {
        print("Error deleting category, \(error)")
    }
    // tableView.reloadData()
}
}

