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
import AuthenticationServices
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var login: UIButtonX!
    @IBOutlet weak var GoogleSignInButton: GIDSignInButton!
    @IBOutlet weak var ForgotPassword: UIButtonX!
    

    var SignInInfo = SingInInfo()
    let user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupKeyBoardObservers()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        login.isEnabled = false
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        image.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        image.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        image.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().clientID = "620661805649-jthc2n6je1rid5f85g17iko2cq58in1s.apps.googleusercontent.com"
//        GoogleSignInButton.translatesAutoresizingMaskIntoConstraints = false
//        GoogleSignInButton.layer.masksToBounds = true
//        GoogleSignInButton.layer.cornerRadius = 14
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
//            view.frame.origin.y = -keyboardRect.height + (1.5*keyboardRect.height/2)
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
            login.isEnabled = true
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            SVProgressHUD.show()
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
                    self.SignInInfo.IDToken = user.authentication.idToken
                    self.SignInInfo.accessToken = user.authentication.accessToken
                    self.handleGoogleSignIn()
                }
            }
        }
    }

    func handleGoogleSignIn() {
        SVProgressHUD.show()
        
        
        let maleRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male")
        let femaleRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female")
        
//        GoogleAuthProvider.credential(withIDToken: SignInInfo.IDToken, accessToken: SignInInfo.accessToken)
        
        var ids = [String]()
        var userids = [String]()
        maleRef.observeSingleEvent(of: DataEventType.value, with: { (snap) in
            
        if snap.hasChild(self.SignInInfo.userID) {
            let ref = maleRef.child(self.SignInInfo.userID)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let snapshotValue = snapshot.value as! NSDictionary
                let name = snapshotValue["Name "] as! String
                let userID = snapshotValue["UserId "] as! String
                let email = snapshotValue["Email "] as! String
                let age = snapshotValue["Age "] as! Int
                let currentUserGender = snapshotValue["Gender "]as! String

                
                userids.append(userID)
                if self.SignInInfo.userID == userID {
                    ids.append(userID)
                    let signInConfirmed = maleRef.child(userID)
                    signInConfirmed.updateChildValues(["Signed In " : "True"])
                    print("THE NAME PASSED IS \(name)")
                    self.user.name = name
                    self.user.id = userID
                    self.user.age = age
                    self.user.CurrentUserGender = currentUserGender
                    self.user.gender = "Female"
                    print("Login Completed")
                    
                    self.performSegue(withIdentifier: "Main", sender: self)
                    SVProgressHUD.dismiss()
                    
                }
            })
            
                
            }else{
//                self.alertUserForSignUp(title: "No user detected with the email", message: "Provide an existing email please.")
//                SVProgressHUD.dismiss()
            
            femaleRef.observeSingleEvent(of: DataEventType.value, with: { (snap) in
                
                if snap.hasChild(self.SignInInfo.userID) {
                    let ref = maleRef.child(self.SignInInfo.userID)
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let snapshotValue = snapshot.value as! NSDictionary
                        let name = snapshotValue["Name "] as! String
                        let userID = snapshotValue["UserId "] as! String
                        let age = snapshotValue["Age "] as! Int
                        let currentUserGender = snapshotValue["Gender "]as! String
                        let email = snapshotValue["Email "] as! String
                        
                        userids.append(userID)
                        
                        if self.SignInInfo.userID == userID {
                            ids.append(userID)
                            
                            let signInConfirmed = femaleRef.child(userID)
                            signInConfirmed.updateChildValues(["Signed In " : "True"])
                            self.user.name = name
                            self.user.id = userID
                            self.user.age = age
                            self.user.CurrentUserGender = currentUserGender
                            self.user.gender = "Male"

                            print("Login Completed")
                            
                            self.performSegue(withIdentifier: "Main", sender: self)
                            SVProgressHUD.dismiss()
                        }
                        
                    })
                    
                }else{
                    self.alertUserForSignUp(title: "No user detected with the email", message: "Provide an existing email please.")
                    SVProgressHUD.dismiss()
                }
            })
            }

        })
      

        
        

      
    }

    func alertUserForSignUp(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        //        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(UIAlertAction(title: "Sign Up", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "FirstName", sender: self)
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleLogin(){
        SVProgressHUD.show()

        
        let maleRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male")
        let femaleRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female")
        
        
        
        maleRef.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as! NSDictionary
            let name = snapshotValue["Name "] as! String
            let userID = snapshotValue["UserId "] as! String
            let email = snapshotValue["Email "] as! String
            let age = snapshotValue["Age "] as! Int
            let currentUserGender = snapshotValue["Gender "] as! String

            if self.emailTextField.text == email {
                print("THE NAME PASSED IS \(name)")
                self.user.name = name
                self.user.id = userID
                self.user.age = age
                self.user.CurrentUserGender = "Male"
                self.user.gender = "Female"

                print("Login Completed")
                
                
                self.performSegue(withIdentifier: "Main", sender: self)
                SVProgressHUD.dismiss()
            }
            
        })
        

        femaleRef.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as! NSDictionary
            let name = snapshotValue["Name "] as! String
            let userID = snapshotValue["UserId "] as! String
            let age = snapshotValue["Age "] as! Int
            let currentUserGender = snapshotValue["Gender "] as! String
            let email = snapshotValue["Email "] as! String
            
            if self.emailTextField.text == email {
                self.user.name = name
                self.user.id = userID
                self.user.age = age
                self.user.CurrentUserGender = "Female"
                self.user.gender = "Male"
                print("Login Completed")

                self.performSegue(withIdentifier: "Main", sender: self)
                SVProgressHUD.dismiss()
                
            }
        })
        
        
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
                    
                    self.handleLogin()
                   
                }
            }
        } else {
            alertTheUser(title: "Email and password are required", message: "Please Provide an email and a password")
            SVProgressHUD.dismiss()
        }
        
    }
    
    @IBAction func ForgotPassword(_ sender: Any) {
        if emailTextField.text!.isEmpty {
            alertTheUser(title: "Please enter your email", message: "")
        }
        let user = Auth.auth()
        user.sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if error != nil {
                print("Error while resetting password \(error?.localizedDescription)")
                self.alertTheUser(title: "No user detected with the email", message: "Provide an existing email please.")
            }
        }
        
    }
    func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OK)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "Main" {

            let destinationVC = segue.destination as! SearchPartnerViewController
            destinationVC.firstNametextLable = user.name
            destinationVC.userID = user.id
            destinationVC.age = user.age
            destinationVC.CurrentUserGender = user.CurrentUserGender
            destinationVC.gender = user.gender
            
//            if user.CurrentUserGender == "Male"{
//                destinationVC.gender = "Female"
//            }else{
//                destinationVC.gender = "Male"
//            }
        }
        else if segue.identifier == "FirstName" {
            let destinationVC = segue.destination as! FirstNameViewController
            destinationVC.emailTextField = SignInInfo.email
            destinationVC.userID = SignInInfo.userID
        }
    }
    
}






















