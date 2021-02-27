//
//  RecipeViewController.swift
//  Recipe Master
//
//  Created by Grant Sivley on 2/23/21.
//

import UIKit

class RecipeViewController: UIViewController {
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var instructionsLabel: UILabel!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
