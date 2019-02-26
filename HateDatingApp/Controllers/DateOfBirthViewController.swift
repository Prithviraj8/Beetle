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
    @IBOutlet weak var DatePickerField: UITextFieldX!
    private var DatePicker : UIDatePicker?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DatePicker = UIDatePicker()
        DatePicker?.datePickerMode = .date
        DatePickerField.inputView = DatePicker
        DatePicker?.addTarget(self, action: #selector(DateOfBirthViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DateOfBirthViewController.viewTapped(gestureRecoginizer:)))
        
        view.addGestureRecognizer(tapGesture)
        setupKeyBoardObservers()
    }

    @objc func viewTapped(gestureRecoginizer: UITapGestureRecognizer) {
        view.endEditing(true)

    }
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        DatePickerField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
   
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
        if segue.identifier == "goToGenderChange" {
            let destinationVC = segue.destination as! GenderViewController
         
            destinationVC.firstNameLabelText = firstNameLabelText
            destinationVC.emailTextField = emailTextField

    }
}
    

}
