//
//  ViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 18/06/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import SVProgressHUD

class ViewController: UIViewController {

    
    var loggedIn : Bool = false
    @IBOutlet weak var toggleMenuView: UIView!
    @IBOutlet weak var getStarted: UIButton!
    @IBOutlet weak var clearFillView: UIViewX!
    @IBOutlet weak var PolicyLabel: UILabel!
    @IBOutlet weak var PolicyButton: UIButton!
    
    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var Login: UIButton!
    var user = User()
    var locationManager = CLLocationManager()
    var notification = NotificationPublisher()
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestLocation()
        
        SignUp.alpha = 0
        Login.alpha = 0
       
        if Auth.auth().currentUser != nil{
//            toggleMenuView.isHidden = true
            PolicyLabel.isHidden = true
            PolicyButton.isHidden = true
            SVProgressHUD.show()
            print("CURRENT USER INFO IS \(String(describing: Auth.auth().currentUser?.email))")
        
     if Auth.auth().currentUser?.email != nil {
        loggedIn = true
        
        
        let maleRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male")
        let femaleRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female")
        
        print("33333")

        
        maleRef.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue!["Name "] as? String
            let currentUserGender = snapshotValue!["Gender "] as? String
            let userID = snapshotValue!["UserId "] as? String
            let email = snapshotValue!["Email "] as? String
            let age = snapshotValue!["Age "] as? Int
            if Auth.auth().currentUser?.uid == userID {
                if name == ""{
                    SVProgressHUD.dismiss()
                }
                print("THE NAME PASSED IS \(name)")
                self.user.name = name!
                self.user.id = userID!
                self.user.age = age
                self.user.CurrentUserGender = "Male"
                self.user.gender = "Female"
                print("1111111")

                self.performSegue(withIdentifier: "Main", sender: self)
//                self.toggleMenuView.isHidden = false
//                self.PolicyLabel.isHidden = false
//                self.PolicyButton.isHidden = false
//                SVProgressHUD.dismiss()
            }
//            SVProgressHUD.dismiss()
        })

        femaleRef.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue!["Name "] as! String
            let currentUserGender = snapshotValue!["Gender "] as! String
            let userID = snapshotValue!["UserId "] as! String
            let age = snapshotValue!["Age "] as? Int
            let email = snapshotValue!["Email "] as! String
            if Auth.auth().currentUser?.uid == userID {
                if name == ""{
                    SVProgressHUD.dismiss()
                }
                self.user.name = name
                self.user.id = userID
                self.user.age = age
                self.user.CurrentUserGender = "Female"
                self.user.gender = "Male"
                print("22222")

                self.performSegue(withIdentifier: "Main", sender: self)
//                self.toggleMenuView.isHidden = false
//                self.PolicyLabel.isHidden = false
//                self.PolicyButton.isHidden = false
//                SVProgressHUD.dismiss()

            }
            SVProgressHUD.dismiss()

        })
//        toggleMenuView.isHidden = false
//        PolicyLabel.isHidden = false
//        PolicyButton.isHidden = false
//        SVProgressHUD.dismiss()

     }else{
            print("ERROR WHILE LOGGING IN \(String(describing: Auth.auth().currentUser?.email))")
            toggleMenuView.isHidden = false
            PolicyLabel.isHidden = false
            PolicyButton.isHidden = false
            loggedIn = false
            SVProgressHUD.dismiss()

            }
        }else{
            toggleMenuView.isHidden = false
            PolicyLabel.isHidden = false
            PolicyButton.isHidden = false
            loggedIn = false
            SVProgressHUD.dismiss()

        }
      
    }
   
    override func viewDidAppear(_ animated: Bool) {
        
        if loggedIn == false{
            SVProgressHUD.dismiss()
            UIView.animate(withDuration: 0.5) {
                self.toggleMenuView.isHidden = false
                self.PolicyLabel.isHidden = false
                self.PolicyButton.isHidden = false
            }
        }
        if CheckInternet.Connection(){
            print("Connected")
        }else{
            print("Not Connected")
            SVProgressHUD.dismiss()
            alertTheUser(title: "No Internet Connection.", message: "Your Device is not connected with internet")
            toggleMenuView.isHidden = false
            PolicyLabel.isHidden = false
            PolicyButton.isHidden = false
        }
    }
    
    @IBAction func getStartedPressed(_ sender: UIButton) {
        
        if self.clearFillView.transform == .identity {
            UIView.animate(withDuration: 0.5, animations: {
                self.clearFillView.transform = CGAffineTransform(scaleX: 10, y: 10)
                self.toggleMenuView.transform = CGAffineTransform(translationX: 0, y: -78)
                //self.getStarted.transform = CGAffineTransform(rotationAngle: 3.14)
            }) { (true) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.toggleShareButtons()
                })
            }
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.toggleMenuView.transform = .identity
                self.getStarted.transform = .identity
                self.clearFillView.transform = .identity
            }) { (true) in
                
            }
        }
    }
    func toggleShareButtons() {
        let alpha = CGFloat(SignUp.alpha == 0 ? 1 : 0)
        SignUp.alpha = alpha
        Login.alpha = alpha
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
    }
    func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OK)
        present(alert, animated: true, completion: nil)
        
    }
  
}



//extension ViewController : CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.requestLocation()
//
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            print(location)
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//
//
//}

