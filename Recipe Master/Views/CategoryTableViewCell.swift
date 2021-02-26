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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryBubble.layer.cornerRadius = categoryBubble.frame.height / 5
        categoryBubble.backgroundColor = RandomFlatColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
