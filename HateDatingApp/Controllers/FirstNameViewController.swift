//
//  FirstNameViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 26/07/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase

class FirstNameViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabelText: UITextField!
    var emailTextField : String = ""
    var passwordTextField : String = ""
    @IBOutlet weak var continuePressed: UIButtonX!
    var userID : String = ""
    var signInInfo = SingInInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupKeyBoardObservers()
        continuePressed.isEnabled = false
        print("GOO ID and email is \(emailTextField)& \(userID)")
    }

    func setupKeyBoardObservers(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        firstNameLabelText.attributedPlaceholder = NSAttributedString(string: "First name",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
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
        }else{
            view.frame.origin.y = 0
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func firstNameTextLabel(_ sender: Any) {
        if (firstNameLabelText.text?.count)! > 0 {
            continuePressed.isHidden = false
            continuePressed.isEnabled = true
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDOB" {
            let destinationVC = segue.destination as! DateOfBirthViewController
            
            destinationVC.firstNameLabelText = firstNameLabelText.text!
            destinationVC.emailTextField = emailTextField
            destinationVC.passwordTextField = passwordTextField
            destinationVC.userID = userID
            print("FIRST NAME PASSED IS \(firstNameLabelText.text!)")
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
