//
//  GenderViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 26/07/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit

class GenderViewController: UIViewController {
    
    var emailTextField : String = ""
    var firstNameLabelText : String = ""
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfileVC" {
            let destinationVC = segue.destination as! profileSetUpViewController
          
            destinationVC.firstNameTextLabel = firstNameLabelText
            destinationVC.emailTextFields = emailTextField
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
