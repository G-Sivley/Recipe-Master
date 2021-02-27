//
//  RecipeTableViewController.swift
//  Recipe Master
//
//  Created by Grant Sivley on 2/23/21.
//

import UIKit
import CoreData
import ViewAnimator

class RecipeTableViewController: UITableViewController {

    var recipeArray = [Recipe]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var selectedCategory : Category? {
        didSet {
            loadRecipes()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.categoryNib, bundle: nil), forCellReuseIdentifier: K.recipeCell)
        self.title = selectedCategory?.name
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.recipeCell, for: indexPath) as! CategoryTableViewCell
        
        let recipe = recipeArray[indexPath.row]
        
        cell.label.text = recipe.name
    
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            let selectedData = recipeArray[indexPath.row]
            
            context.delete(selectedData)
            saveData()
            recipeArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let destinationVC = segue.destination as! RecipeViewController
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedRecipe = recipeArray[indexPath.row]
        
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segue.segueToRecipeView, sender: self)
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
    
    
    
    func loadRecipes(with request: NSFetchRequest<Recipe> = Recipe.fetchRequest()) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        request.predicate = categoryPredicate
        
        do {
            recipeArray =  try context.fetch(request)
        } catch {
            print("Error occurred in loading categories: \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add Recipe
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Recipe", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Recipe", style: .default) { (action) in
            // what happens when the add category button is clicked
            
            if let text = textField.text, textField.text != "" {
                let newRecipe = Recipe(context: self.context)
                newRecipe.name = text
                newRecipe.parentCategory = self.selectedCategory
                
                self.recipeArray.append(newRecipe)
                self.saveData()
                self.tableView.reloadData()
                
            } else {
                // Need to add stuff here to make sure the User gets a notification that they need to redo it
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Recipe Here"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
