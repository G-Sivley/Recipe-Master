//
//  CategoryTableViewCell.swift
//  Recipe Master
//
//  Created by Grant Sivley on 2/24/21.
//

import UIKit
import ChameleonFramework

class CategoryTableViewCell: UITableViewCell {
  
    @IBOutlet weak var categoryBubble: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var sfSymbolView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryBubble.layer.cornerRadius = categoryBubble.frame.height / 5
        // categoryBubble.backgroundColor = RandomFlatColor()
        
        // change the accesssory to the color of choice
        
        sfSymbolView.image = UIImage(systemName: "chevron.forward.circle")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
