//
//  ChangeInfoViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 27/02/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChangeInfoViewController: UIViewController {


    @IBOutlet weak var changeButton: UIButtonX!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    var firstNametextLable : String = ""
    var userID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        email.text = Auth.auth().currentUser?.email
        
    }

    @IBAction func backButton(_ sender: Any) {

    }
    
    
    @IBAction func changeButtonPressed(_ sender: Any) {
//        SVProgressHUD.show()
        
        if newEmail.text != "" {
            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male").child((userID))
            ref.updateChildValues(["Email ": self.newEmail.text!])
            
            Auth.auth().currentUser?.updateEmail(to: newEmail.text!, completion: { (error) in
                if error != nil {
                    print("THE userID \(Auth.auth().currentUser?.uid) new email is \(self.newEmail.text!)")
                    
//                    SVProgressHUD.dismiss()
                    //Logging/Signing out the user.
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil )
                    let initialVC = storyBoard.instantiateViewController(withIdentifier: "ViewController")
                    self.present(initialVC, animated: true, completion: nil)
                    
                }else{
                    print("ERROR ISSS \(error?.localizedDescription)")
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil )
                    let initialVC = storyBoard.instantiateViewController(withIdentifier: "ViewController")
                    self.present(initialVC, animated: true, completion: nil)
                }
            })
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToSettings" {
            let VC = segue.destination as! SettingsViewController
            VC.firstNametextLable = firstNametextLable
            VC.userID = userID
            dismiss(animated: true, completion: nil)

        }
    }
    
}
