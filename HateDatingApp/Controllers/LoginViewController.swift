//
//  LoginViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 21/06/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
//import RealmSwift
import Firebase
import SVProgressHUD


class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func LogInButtonPress(_ sender: UIButton) {
        
//        SVProgressHUD.show()
//
//        //TODO: Log in the user
//        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
//
//             if error != nil {
//                print(error)
//                self.alertTheUser(title: " ", message: "Please enter email and password")
//            }else {
//                print("Log in was successful")
//                SVProgressHUD.dismiss()
//
//            }
//
//        }

        if emailTextField.text != "" && passwordTextField.text != "" {
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!) { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem with Authentication", message: message!)
                } else {
                    print("Login Completed")
                    //self.performSegue(withIdentifier: "goToSelectPartner", sender: self)
                }
            }
        } else {
            alertTheUser(title: "Email and password are required", message: "Please Provide an email and a password")
        }
        
    }
    
     func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OK)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "goToSearchPartner" {
            
            let destinationVC = segue.destination as! SearchPartnerViewController
          //      destinationVC.userid = userid!
            
        }
    }
    
}




















