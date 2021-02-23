//
//  CategoriesTableViewController.swift
//  Master Recepie
//
//  Created by Grant Sivley on 2/21/21.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {
    
    var categoriesArray = [Category]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        // Uncomment the print statement below to print Core File path
        // print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last?.absoluteString.removingPercentEncoding ?? "Not found")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as UITableViewCell
        
        let category = categoriesArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }


    // Override to support editing the table view.
    
    // Need to fix this somehow
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
            print("I just saved categories")
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        do {
            categoriesArray =  try context.fetch(Category.fetchRequest())
        } catch {
            print("Error occurred in loading categories: \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    //MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
}
