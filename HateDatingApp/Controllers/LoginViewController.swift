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
    
    let user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
            view.frame.origin.y = -keyboardRect.height + (1.5*keyboardRect.height/2)
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                
            }
        }else{
            view.frame.origin.y = 0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                
            }
        }
    }
    
    
    @IBAction func LogInButtonPress(_ sender: UIButton) {
        
        SVProgressHUD.show()

        if emailTextField.text != "" && passwordTextField.text != "" {
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!) { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem with Authentication", message: message!)
                    SVProgressHUD.dismiss()
                    return
                } else {
                    
                    self.dismiss(animated: true, completion: nil)
                    print("Login Completed")
                    Handler.Instance.female = self.emailTextField.text!
                    SVProgressHUD.dismiss()
                    
                    let maleRef = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Male")
                    let femaleRef = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Female")

                    let maleVC = SearchPartnerViewController()
                    let femaleVC = FemaleSearchPartnerViewController()
                    
                    maleRef.observe(.childAdded, with: { (snapshot) in
                        let snapshotValue = snapshot.value as! NSDictionary
                        let name = snapshotValue["Name "] as! String

                        let email = snapshotValue["Email "] as! String
                        if self.emailTextField.text == email {
                            print("THE NAME PASSED IS \(name)")
                            self.user.name = name
                            maleVC.firstNametextLable = name
                            self.performSegue(withIdentifier: "goToMaleSelectPartner", sender: self)
                        }
                       
                    })

                    femaleRef.observe(.childAdded, with: { (snapshot) in
                        let snapshotValue = snapshot.value as! NSDictionary
                        let name = snapshotValue["Name "] as! String

                        let email = snapshotValue["Email "] as! String
                        if self.emailTextField.text == email {
                            femaleVC.firstNametextLable = name
                            self.user.name = name

                            self.performSegue(withIdentifier: "goToFemaleSelectPartner", sender: self)
                        }
                    })
                }
            }
        } else {
            alertTheUser(title: "Email and password are required", message: "Please Provide an email and a password")
            SVProgressHUD.dismiss()
        }
        
    }
    
     func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OK)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "goToMaleSelectPartner" {

            let destinationVC = segue.destination as! SearchPartnerViewController
            destinationVC.firstNametextLable = user.name
            
        }else if segue.identifier == "goToFemaleSelectPartner" {
            let ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Female")
            let destinationVC = segue.destination as! FemaleSearchPartnerViewController
            destinationVC.firstNametextLable = user.name

        }
    }
    
}




















