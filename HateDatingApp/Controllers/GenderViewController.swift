//
//  GenderViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 26/07/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase

class GenderViewController: UIViewController {
    
    var emailTextField : String = ""
    var firstNameLabelText : String = ""
    var gender : String = ""
    
    @IBOutlet weak var womanButton: UIButtonX!
    @IBOutlet weak var manButton: UIButtonX!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addGenderToDatabase()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfileVC" {
            let destinationVC = segue.destination as! profileSetUpViewController
          
            destinationVC.firstNameTextLabel = firstNameLabelText
            destinationVC.emailTextFields = emailTextField
            destinationVC.gender = "Male"
            
        } else if segue.identifier == "goToFemaleProfileVC" {
            let destinationVC = segue.destination as! profileSetUpViewController
            
            destinationVC.firstNameTextLabel = firstNameLabelText
            destinationVC.emailTextFields = emailTextField
            destinationVC.gender = "Female"
        }
    }

    
    func addGenderToDatabase(){

   
        if womanButton.isSelected {
            gender = "Male"
        }else{
            gender = "Female"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
