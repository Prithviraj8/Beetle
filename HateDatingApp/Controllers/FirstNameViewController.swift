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
            view.frame.origin.y = -keyboardRect.height
        }else{
            view.frame.origin.y = 0
        }
        
        
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
