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
    var passwordTextField : String = ""
    var messages = message()
    var userID : String = ""
    @IBOutlet weak var DatePickerField: UITextFieldX!
    @IBOutlet weak var continuePressed: UIButtonX!
    
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
        DatePickerField.attributedPlaceholder = NSAttributedString(string: "Pick your birthdate",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        setupKeyBoardObservers()
        
        continuePressed.setGradientBackground(colorOne: Colors.darkBlue, colorTwo: Colors.lightBlue)
    }

    @objc func viewTapped(gestureRecoginizer: UITapGestureRecognizer) {
        view.endEditing(true)

    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        DatePickerField.text = dateFormatter.string(from: datePicker.date)

        let DOB = calculateAge(datePicker: DatePickerField.text!)
        print("AGE IS \(DOB)")
        messages.age = DOB 
    }
    
    
    
    func calculateAge(datePicker: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        print("DATE IS \(DatePickerField.text!)")
        let birthdayDate = dateFormatter.date(from: datePicker)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        print("Current date IS \(now)")
        print("BDAY is \(birthdayDate)")
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
        
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
//            view.frame.origin.y = -keyboardRect.height
        }else{
            view.frame.origin.y = 0
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        //        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func continuePressed(_ sender: Any) {
        if messages.age == nil {
            alertTheUser(title: "Your age is required to create a profile.", message: "Please enter your age")
        }else{
            performSegue(withIdentifier: "goToGenderChange", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGenderChange" {
            let destinationVC = segue.destination as! GenderViewController
           
            destinationVC.firstNameLabelText = firstNameLabelText
            destinationVC.emailTextField = emailTextField
            destinationVC.passwordTextField = passwordTextField
            destinationVC.age = messages.age
            destinationVC.userID = userID
            print("AGE PASSED IS \(messages.age)")
        }
    }
}
