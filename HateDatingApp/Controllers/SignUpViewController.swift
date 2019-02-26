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

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var SignInPressed: UIButtonX!
//    var user: [User] = [User]()
    var messages = message()
   // var userUid: String! = NSUUID
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        SignInPressed.backgroundColor = .gray
        SignInPressed.isEnabled = false
       setupKeyBoardObservers()
    }

    func setupKeyBoardObservers(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
    }
    
    @objc func handleKeyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height + (keyboardRect.height/2)
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                
            }
        }else{
            view.frame.origin.y = 0
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            return true
    }
    
    @IBAction func passwordTextField(_ sender: Any) {
        if (passwordTextField.text?.count)! >= 6 {
            SignInPressed.backgroundColor = .red
            SignInPressed.isEnabled = true
        }
        
    }
    
    @IBAction func SignInPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()

        //TODO: Set up a new user on our Firbase database
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in

                
            /*   This is a closure. A closure is a function with no name. Therefore when performing a Segue in a closure always remember to add a
             self.  before performSegue method as done below.  */

            if (user != nil) {
                //Success
                
                print("Registration Successful")
              self.performSegue(withIdentifier: "segueToFirstName", sender: self)
                SVProgressHUD.dismiss()

        
            } else {
                print("ERROR WHILE SIGNING UP IS :: \(error?.localizedDescription)")
                if(error != nil){
                    self.alertTheUser(title: (error?.localizedDescription)!, message: "Email eg: test@mail.com ")
                    SVProgressHUD.dismiss()

                }

            }
        }

        } else{
            self.alertTheUser(title: " Email and Password required ", message: "Please enter email and password")
        }
        
    }
  
    func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        //        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segueToFirstName" {
            let destinationVC = segue.destination as! FirstNameViewController
            
            destinationVC.emailTextField = emailTextField.text!
        }else{
               print("View controller not found")

        }
    }
}
