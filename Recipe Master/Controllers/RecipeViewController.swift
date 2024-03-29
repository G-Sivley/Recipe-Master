//
//  RecipeViewController.swift
//  Recipe Master
//
//  Created by Grant Sivley on 2/23/21.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var instructionsTableView: UITableView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    var instructionArray = [RecipeInstruction]()
    var ingredientArray = [Ingredient]()
    
    let imagePicker = UIImagePickerController()
    
    // var alertPresenter = AlertPresenter()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedRecipe : Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets the image in the image view
        if let selectedRecipeImage = selectedRecipe?.image {
            showImage(TorF: true)
            recipeImageView.image = UIImage(data: selectedRecipeImage, scale: 1.0)
        }
        
        instructionsTableView.dataSource = self
        ingredientTableView.dataSource = self
        
        cameraSetup()
        
        loadRecipe()
        self.title = selectedRecipe?.name
        recipeImageView.layer.cornerRadius = recipeImageView.frame.height / 5
    
        addMenu()
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
        let recipePredicate = NSPredicate(format: "parentRecipe.name MATCHES %@", selectedRecipe!.name!)
        
        let ingredientRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        
        let instructionRequest: NSFetchRequest<RecipeInstruction> = RecipeInstruction.fetchRequest()
        
        do {
            ingredientRequest.predicate = recipePredicate
            ingredientArray =  try context.fetch(Ingredient.fetchRequest())
        } catch {
            print("Error occurred in loading ingredients: \(error)")
        }
        
        do {
            instructionRequest.predicate = recipePredicate
            instructionArray = try context.fetch(instructionRequest)
        } catch {
            print("There was an error in loading instructions")
        }
        instructionsTableView.reloadData()
        ingredientTableView.reloadData()
        
    }
    
    func deleteInstructions(data: RecipeInstruction, path: IndexPath) {
        context.delete(data)
        saveData()
        instructionArray.remove(at: path.row)
        instructionsTableView.deleteRows(at: [path], with: .fade)
        
    }
    
    @IBAction func addImagePressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        showImage(TorF: true)
        instructionsTableView.isEditing = false
    }
    
}

//MARK: - Table SetUp

extension RecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == instructionsTableView {
            return instructionArray.count
        } else {
            return ingredientArray.count
           
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == instructionsTableView {
            let cell = instructionsTableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath) as UITableViewCell
            
            if let instruction = instructionArray[indexPath.row].name {
                cell.textLabel?.text = "\(indexPath.row + 1).) \(instruction)"
                
            }
            return cell
            
        } else {
            let cell = ingredientTableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath) as UITableViewCell
            
       
            if let ingredient = ingredientArray[indexPath.row].name {
                cell.textLabel?.text = ingredient
            }
            
            return cell
        }
        
    }
    
    //MARK: - Add Menu
    
    private func addMenu() {
        let menu = UIMenu(title: "Add item", children: [instructionMenuItem(), ingredientMenuItem()])
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), primaryAction: nil, menu: menu)
    }
    
    private func instructionMenuItem() -> UIAction {
        UIAction(title: "Add Instruction", handler: { (_) in
            
            var textField = UITextField()

            let alert = UIAlertController(title: "Add New Instruction", message: "", preferredStyle: .alert)

            let action = UIAlertAction(title: "Add Instruction", style: .default) { (action) in
                // what happens when the add category button is clicked

                if let text = textField.text, textField.text != "" {

                    let newInstruction = RecipeInstruction(context: self.context)
                    newInstruction.name = text.capitalized
                    newInstruction.parentRecipe = self.selectedRecipe

                    self.instructionArray.append(newInstruction)
                    self.saveData()
                    self.loadRecipe()

                } else {

                    self.showBasicAlert(alertText: "Empty Text Bar", alertMessage: "Please fill in the text bar")

                }
            }

            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "New Instruction Here"
                textField = alertTextField
            }

            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    private func ingredientMenuItem() -> UIAction {
        UIAction(title: "Add Ingredient", handler: { (_) in
            var textField = UITextField()

            let alert = UIAlertController(title: "Add New Ingredient", message: "", preferredStyle: .alert)

            let action = UIAlertAction(title: "Add Ingredient", style: .default) { (action) in
                // what happens when the add category button is clicked

                if let text = textField.text, textField.text != "" {

                    let newIngredient = Ingredient(context: self.context)
                    newIngredient.name = text.capitalized
                    newIngredient.done = false
                    newIngredient.parentRecipe = self.selectedRecipe

                    self.ingredientArray.append(newIngredient)
                    self.saveData()
                    self.loadRecipe()

                } else {

                    self.showBasicAlert(alertText: "Empty Text Bar", alertMessage: "Please fill in the text bar")

                }
            }

            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "New Ingredient Here"
                textField = alertTextField
            }

            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        })

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
    
    @IBAction func didTapEdit() {
        if instructionsTableView.isEditing {
            instructionsTableView.isEditing = false
            showImage(TorF: true)
        } else {
            instructionsTableView.isEditing = true
            showImage(TorF: false)
        }
    }
}

//MARK: - Image Selection

extension RecipeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let imageData = userPickedImage.jpegData(compressionQuality: 0.5)
            selectedRecipe?.image = imageData
            saveData()
            
            recipeImageView.image = userPickedImage
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func showImage(TorF: Bool) {
        
        if TorF {
            recipeImageView.isHidden = false
            imageButton.isHidden = true
        } else {
            recipeImageView.isHidden = true
            imageButton.isHidden = false
        }
    }
    
    
}

extension RecipeViewController: UINavigationControllerDelegate{
    
}

//MARK: - Camera Setup

extension RecipeViewController {
    
    func cameraSetup() {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.showsCameraControls = true
    }
    
}
