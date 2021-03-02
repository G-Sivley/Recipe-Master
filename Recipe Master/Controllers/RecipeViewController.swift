//
//  RecipeViewController.swift
//  Recipe Master
//
//  Created by Grant Sivley on 2/23/21.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var instructionsTableView: UITableView!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var instructionArray = [RecipeInstruction]()
    var ingredientArray = [Ingredient]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedRecipe : Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionsTableView.dataSource = self
        
        loadRecipe()
        self.title = selectedRecipe?.name
        recipeImage.layer.cornerRadius = recipeImage.frame.height / 5
       
        
    }
    
    //MARK: - Add Button Pressed
    
    @IBAction func addRecipeIntructionsPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Instruction", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Instruction", style: .default) { (action) in
            // what happens when the add category button is clicked
            
            if let text = textField.text, textField.text != "" {
                let newInstruction = RecipeInstruction(context: self.context)
                newInstruction.name = text
                newInstruction.parentRecipe = self.selectedRecipe
                
                self.instructionArray.append(newInstruction)
                self.saveData()
                self.loadRecipe()
                
                
            } else {
                // Need to add stuff here to make sure the User gets a notification that they need to redo it
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Instruction Here"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: - Data Manipulation Methods
    func saveData() {
        do {
            try context.save()
            
        } catch {
            print("There was an error saving data")
        }
    }
    
    func loadRecipe() {
        do {
            ingredientArray =  try context.fetch(Ingredient.fetchRequest())
        } catch {
            print("Error occurred in loading ingredients: \(error)")
        }
        
        do {
            instructionArray = try context.fetch(RecipeInstruction.fetchRequest())
        } catch {
            print("There was an error in loading instructions")
        }
        instructionsTableView.reloadData()
        
    }
    
    func deleteInstructions(data: RecipeInstruction, path: IndexPath) {
        context.delete(data)
        saveData()
        instructionArray.remove(at: path.row)
        instructionsTableView.deleteRows(at: [path], with: .fade)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//MARK: - Table SetUp

extension RecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = instructionsTableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath) as UITableViewCell
        
        if let instruction = instructionArray[indexPath.row].name {
            cell.textLabel?.text = "\(indexPath.row + 1).) \(instruction)"
            
        }
        return cell
    }
}


//MARK: - Table Manipulation
extension RecipeViewController: UITableViewDelegate {
    
    // need to set up a way to edit rows
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        instructionArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        instructionsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedData = instructionArray[indexPath.row]
            
            deleteInstructions(data: selectedData, path: indexPath)
        }
    }
    
    @IBAction func didTapSort() {
        if instructionsTableView.isEditing {
            instructionsTableView.isEditing = false
        } else {
            instructionsTableView.isEditing = true
        }
    }
}

