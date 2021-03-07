//
//  ViewControllerExtensions.swift
//  Recipe Master
//
//  Created by Grant Sivley on 3/7/21.
//

import UIKit

extension UIViewController {
    //Show a basic alert
    
    func showBasicAlert(alertText : String, alertMessage : String) {
        
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
}
