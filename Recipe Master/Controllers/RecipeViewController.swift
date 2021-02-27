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
    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    var instructionsArray = RecipeInstructions
    var ingredientArray = [Ingredient]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedRecipe : Recipe? {
        didSet {
            //loadIngredients()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = selectedRecipe?.name
        recipeImage.layer.cornerRadius = recipeImage.frame.height / 5
        instructionsView.layer.cornerRadius = instructionsView.frame.height / 8
        
    }
    
    //MARK: - Add Button Pressed
    
    @IBAction func addRecipeIntructionsPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Ingredient", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Ingredient", style: .default) { (action) in
            // what happens when the add category button is clicked
            
            if let text = textField.text, textField.text != "" {
                let newIngredient = Ingredient(context: self.context)
                newIngredient.name = text
                newIngredient.parentRecipe = self.selectedRecipe
                
                self.ingredientArray.append(newIngredient)
                self.saveData()
                // create a reload data method
                
            } else {
                // Need to add stuff here to make sure the User gets a notification that they need to redo it
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Ingredient Here"
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
