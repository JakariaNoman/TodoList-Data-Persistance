//
//  CategoryViewController.swift
//  MyTodoList
//
//  Created by Jakaria Noman on 10/2/25.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var category = [Category]()
    var jakaria = 10
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

// MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        category.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category[indexPath.row].name
        return cell
    }
    
// MARK: - Data Manipulation Methods
    
    private func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error Saving Context \(error)")
        }
        tableView.reloadData()
    }
    
    private func loadCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            category = try context.fetch(request)
        } catch {
            print("Error Categories Error:\(error)")
        }
        tableView.reloadData()
    }
    
// MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.didSelectCategory = category[indexPath.row]
        }
    }
    
// MARK: - Add New Categories
    
    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        
            var textField = UITextField()
            let alertController = UIAlertController(
                title: "Add New  Category",
                message: "",
                preferredStyle: .alert
            )
            
            let alertAction =  UIAlertAction(
                title: "Add Category",
                style: .default) { [weak self] action in
                    guard let self else { return }
        
                    if let safeData = textField.text {
                        let newItem = Category(context: self.context) // create new entities 
                        newItem.name = safeData
                        category.append(newItem)
                        saveCategories()
                    }
                }
            
            alertController.addTextField { alertTextField in
                textField = alertTextField
            }
            
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
    }
}
