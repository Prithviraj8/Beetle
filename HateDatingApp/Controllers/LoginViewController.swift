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
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var login: UIButtonX!
    @IBOutlet weak var GoogleSignInButton: GIDSignInButton!
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
        GoogleSignInButton.layer.cornerRadius = 15
        GoogleSignInButton.layer.shadowOpacity = 1
        GoogleSignInButton.layer.shadowRadius = 6
        
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
                    self.handleLogin()
                    
                }
            }
        }
    }
    
    func handleLogin(){
        print("Login Completed")
        SVProgressHUD.show()
        let maleRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male")
        let femaleRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female")
        
        
        
        maleRef.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as! NSDictionary
            let name = snapshotValue["Name "] as! String
            let userID = snapshotValue["UserId "] as! String
            let email = snapshotValue["Email "] as! String
            let age = snapshotValue["Age "] as! Int
            if self.emailTextField.text == email {
                print("THE NAME PASSED IS \(name)")
                self.user.name = name
                self.user.id = userID
                self.user.age = age
                self.performSegue(withIdentifier: "goToMaleSelectPartner", sender: self)
                SVProgressHUD.dismiss()
            }
            
        })
        
        
        femaleRef.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as! NSDictionary
            let name = snapshotValue["Name "] as! String
            let userID = snapshotValue["UserId "] as! String
            let age = snapshotValue["Age "] as! Int

            let email = snapshotValue["Email "] as! String
            if self.emailTextField.text == email {
                self.user.name = name
                self.user.id = userID
                self.user.age = age

                self.performSegue(withIdentifier: "goToFemaleSelectPartner", sender: self)
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
            destinationVC.userID = user.id
            destinationVC.age = user.age
        }else if segue.identifier == "goToFemaleSelectPartner" {
            let destinationVC = segue.destination as! FemaleSearchPartnerViewController
            destinationVC.firstNametextLable = user.name
            destinationVC.userID = user.id
//            destinationVC.age = user.age

        }
    }
    
}






















