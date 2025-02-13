//
//  ViewController.swift
//  MyTodoList
//
//  Created by Jakaria Noman on 14/1/25.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var didSelectCategory: Category? {
        didSet {
            loadData()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
// MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        cell.layer.cornerRadius = 10
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /* Delete a row from todo List
              context.delete(itemArray[indexPath.row])
              itemArray.remove(at: indexPath.row)
         */
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        saveData()
    }
    
   //MARK : ADD New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alertController = UIAlertController(
            title: "Add New ToDoList Item",
            message: "",
            preferredStyle: .alert)
        
        let alertAction =  UIAlertAction(
            title: "Add Item",
            style: .default) { [weak self] action in
                guard let self else { return }
    
                if let safeData = textField.text {
                    
                    let newItem = Item(context: context)
                    newItem.title = safeData
                    newItem.done = false
                    newItem.parentCategory = self.didSelectCategory
                    itemArray.append(newItem)
                    saveData()
                }
            }
        
        alertController.addTextField { alertTextField in
            textField = alertTextField
        }
        
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
    
    //save Data Using NSCODER with prespecified file path
    func saveData() {
        do {
          try context.save()
        } catch {
            print("Error Saving Context \(error)")
        }
        tableView.reloadData()
    }
    
    //load Save Data Using "NSCODER" with prespecified file path
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // when we call loadData() but we don't pass any request to loadData ,In that case it will use default request value
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", didSelectCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}
//MARK: - Search Bar Methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //To read data from Context, we have to create a request and we have to declare request data type
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        loadData(with : request, predicate : predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData() // when we don't pass any request to loadData ,In this case it will use default request value
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // it removes cursor and keyboard from ui 
            }
        }
    }
}
