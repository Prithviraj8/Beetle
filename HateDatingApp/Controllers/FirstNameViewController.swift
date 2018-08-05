//
//  FirstNameViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 26/07/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit

class FirstNameViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabelText: UITextField!
    var emailTextField : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDOB" {
            let destinationVC = segue.destination as! DateOfBirthViewController
            
            destinationVC.firstNameLabelText = firstNameLabelText.text!
            destinationVC.emailTextField = emailTextField
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
