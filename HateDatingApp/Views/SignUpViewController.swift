//
//  SignUpViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 21/06/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
//import RealmSwift
import Firebase
import SVProgressHUD
import ChameleonFramework

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func SignInPressed(_ sender: UIButton) {
        
//       SVProgressHUD.show()
//
//        //TODO: Set up a new user on our Firbase database
//
//        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
//
//            /*   This is a closure. A closure is a function with no name. Therefore when performing a Segue in a closure always remember to add a
//             self.  before performSegue method as done below.  */
//
//            if (error != nil) {
//                print(error)
//                self.alertTheUser(title: " ", message: "Please enter email and password")
//
//            } else {
//                //Success
//                print("Registration Successful")
//                SVProgressHUD.dismiss()
//
//            }
//        }
//
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!) { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem with creating a new user", message: message!)
                } else {
                    print("User successfully created")
                }
            }
            
        } else {
            alertTheUser(title: "Email and Password required", message: "Please Provide an email id and a password")
            //SVProgressHUD.dismiss()

        }

        
        
    }
    
     func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OK)
        present(alert, animated: true, completion: nil)
        
    }
    

}
