//
//  PasswordChangeViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 10/03/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PasswordChangeViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var currentPassword: UITextFieldX!
    @IBOutlet weak var newPassword: UITextFieldX!
    @IBOutlet weak var incorrectPasswordMSG: UILabel!
    
    var firstNametextLable : String!
    var currentUserGender : String!
    var gender : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentPassword.delegate = self
        newPassword.delegate = self
        incorrectPasswordMSG.isHidden = true
        print("EM IS \(Auth.auth().currentUser?.email)")
    }

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func currentPasswordField(_ sender: Any) {

        let user = Auth.auth().currentUser
        let email = Auth.auth().currentUser?.email
        
        let credential = EmailAuthProvider.credential(withEmail: email!, password: currentPassword.text!)
        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child(currentUserGender).child((Auth.auth().currentUser?.uid)!)
 
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
        let user = Auth.auth().currentUser
        let email = Auth.auth().currentUser?.email
        
        let credential = EmailAuthProvider.credential(withEmail: email!, password: currentPassword.text!)
        
        
        if newPassword.text != "" {
            SVProgressHUD.show()
            user?.reauthenticateAndRetrieveData(with: credential, completion: { (result, error) in
                if error != nil{
                    print("Error changing user's password")
                    self.alertTheUser(title: "Reset Password", message: "Current Entered Password is wrong")
                    SVProgressHUD.dismiss()
                }else{
                    //change to new password
                    user?.updatePassword(to: self.newPassword.text!, completion: nil)
                    //Signing out the user.
                    self.alertTheUser(title: "Reset Password", message: "Your Password has been changed successfully.")
                    
                    
                    SVProgressHUD.dismiss()
                    
                }
            })
        }
     
    }
    
    func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert)
        //        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil )
            let initialVC = storyBoard.instantiateViewController(withIdentifier: "ViewController")
            self.present(initialVC, animated: true, completion: nil)
            
            alert.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToSettings" {
            let VC = segue.destination as! SettingsViewController
            VC.firstNametextLable = firstNametextLable
            VC.currentUserGender = currentUserGender
            VC.gender = gender
            dismiss(animated: true, completion: nil)

        }
    }

}
