//
//  DateOfBirthViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 02/07/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase

class DateOfBirthViewController: UIViewController {

    var emailTextField : String = ""
    var firstNameLabelText : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
//    @IBAction func ContinuePressed(_ sender: UIButtonX) {
//        
////        let vc = profileSetUpViewController(nibName: "profileSetUpViewController", bundle: nil)
////        vc.firstNameTextLabel = firstNameLabelText.text!
////        vc.emailTextFields = emailTextField
////
////        navigationController?.popViewController(animated: true)
//        
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGenderChange" {
            let destinationVC = segue.destination as! GenderViewController
         
            destinationVC.firstNameLabelText = firstNameLabelText
            destinationVC.emailTextField = emailTextField

    }
}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
