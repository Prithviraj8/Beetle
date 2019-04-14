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
import GoogleSignIn

class SignUpViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
  
    
    @IBOutlet weak var emailTextField: UITextFieldX!
    @IBOutlet weak var passwordTextField: UITextFieldX!
    @IBOutlet weak var SignInPressed: UIButtonX!
    @IBOutlet weak var GoogleSignInButton: GIDSignInButton!
    @IBOutlet weak var image: UIImageView!
    //    var user: [User] = [User]()
    var messages = message()
    var SignInInfo = SingInInfo()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        SignInPressed.isEnabled = false
        setupKeyBoardObservers()
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//         (equalTo: self.view.bottomAnchor).isActive = true
//        image.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        image.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().clientID = "620661805649-jthc2n6je1rid5f85g17iko2cq58in1s.apps.googleusercontent.com"
        GoogleSignInButton.layer.cornerRadius = 15
        GoogleSignInButton.layer.shadowOpacity = 1
        GoogleSignInButton.layer.shadowRadius = 6
        SignInPressed.setGradientBackground(colorOne: Colors.darkBlue, colorTwo: Colors.lightBlue)
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
//            view.frame.origin.y = -keyboardRect.height + (keyboardRect.height/2)
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
    
    func textFieldShouldReturn(_ textField: UITextFieldX) -> Bool {
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            return true
    }
    
    @IBAction func passwordTextField(_ sender: Any) {
        if (passwordTextField.text?.count)! >= 6 {
            SignInPressed.isEnabled = true
        }
        
    }

    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print("ERROR WHILE GOOGLE SIGNING IN IS \(error.localizedDescription)")
        }else{
            print("SUCCESSFULLY LOGGED IN GOOGLE USER \(user)")
            let credentials = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            
            Auth.auth().signInAndRetrieveData(with: credentials) { (result, err) in
                if err != nil {
                    print("ERROR \(String(describing: err))")
                }else{
                    self.SignInInfo.email = (result?.user.email)!
                    self.SignInInfo.name = (result?.user.displayName)!
                    self.SignInInfo.userID = (result?.user.uid)!
                    print("Google users uid is \(result!.user.uid))")
                    self.performSegue(withIdentifier: "segueToFirstName", sender: self)
                    
                }
            }
        }
    }
    
    @IBAction func SignInPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()

        //TODO: Set up a new user on our Firbase database
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in

                print("IS EMAIL VALIDATED \(self.validateEmail(enteredEmail: self.emailTextField.text!))")

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
    
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
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
            if emailTextField.text != "" {
                destinationVC.emailTextField = emailTextField.text!
                destinationVC.passwordTextField = passwordTextField.text!
                print("TEXTS ARE \(emailTextField.text)")
                destinationVC.userID = Auth.auth().currentUser!.uid
            }else{
                print("PASSING GOOGLE USERS INFO ")
                destinationVC.emailTextField = SignInInfo.email
                destinationVC.userID = SignInInfo.userID
            }
       
        }
    }
    
    
    enum LINE_POSITION {
        case LINE_POSITION_TOP
        case LINE_POSITION_BOTTOM
    }
    
    func addLineToView(view : UIView, position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        view.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        default:
            break
        }
    }
}
