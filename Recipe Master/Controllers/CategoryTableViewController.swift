//
//  CategoriesTableViewController.swift
//  Master Recepie
//
//  Created by Grant Sivley on 2/21/21.
//

import UIKit
import CoreData
import ViewAnimator

class CategoriesTableViewController: UITableViewController {
    
    var categoriesArray = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var animationHasBeenShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Registers the custom cell as the category cell name
        
        tableView.register(UINib(nibName: K.categoryNib, bundle: nil), forCellReuseIdentifier: K.categoryCell)

        loadCategories()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !animationHasBeenShow {
            animationHasBeenShow = true
            let animation = AnimationType.vector(CGVector(dx: -250, dy: 0))
            UIView.animate(views: tableView.visibleCells, animations: [animation], initialAlpha: 0.0, finalAlpha: 1.0, duration: 0.6)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCell, for: indexPath) as! CategoryTableViewCell
        
        let category = categoriesArray[indexPath.row]
        
        cell.label.text = category.name
        
        return cell
    }


    // Override to support editing the table view.
    
    // Need to fix this somehow
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            let selectedData = categoriesArray[indexPath.row]
            
            context.delete(selectedData)
            saveData()
            categoriesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segue.segueToRecipeTable, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! RecipeTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveData() {
        do {
            try context.save()
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
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Recipe Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what happens when the add category button is clicked
            
            if let text = textField.text, textField.text != "" {
                let newCategory = Category(context: self.context)
                newCategory.name = text
                
                self.categoriesArray.append(newCategory)
                self.saveData()
                
            } else {
                // Need to add stuff here to make sure the User gets a notification that they need to redo it
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category Here"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
