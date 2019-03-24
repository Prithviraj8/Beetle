//
//  ViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 18/06/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import MapKit
import SwiftKeychainWrapper
import Firebase
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var toggleMenuView: UIView!
    @IBOutlet weak var getStarted: UIButton!
    @IBOutlet weak var clearFillView: UIViewX!
    
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
            SVProgressHUD.show()

            print("CURRENT USER INFO IS \(Auth.auth().currentUser?.uid)")
//            Timer.scheduledTimer(withTimeInterval: 0, repeats: false) { (Timer) in
            
                let maleRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male")
                let femaleRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female")
            
            
            
                maleRef.observe(.childAdded, with: { (snapshot) in
                    let snapshotValue = snapshot.value as! NSDictionary
                    let name = snapshotValue["Name "] as! String
                    let userID = snapshotValue["UserId "] as! String
                    let email = snapshotValue["Email "] as! String
                    let age = snapshotValue["Age "] as! Int
                if Auth.auth().currentUser?.email != nil {
                    if Auth.auth().currentUser?.email == email {
                        print("THE NAME PASSED IS \(name)")
                        self.user.name = name
                        self.user.id = userID
                        self.user.age = age
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "Male", sender: self)
                    }else{
                        
                        femaleRef.observe(.childAdded, with: { (snapshot) in
                            let snapshotValue = snapshot.value as! NSDictionary
                            let name = snapshotValue["Name "] as! String
                            let userID = snapshotValue["UserId "] as! String
                            
                            let email = snapshotValue["Email "] as! String
                            if Auth.auth().currentUser?.email == email {
                                self.user.name = name
                                self.user.id = userID
                                self.user.age = age

                                SVProgressHUD.dismiss()
                                self.performSegue(withIdentifier: "Female", sender: self)
                            }else{
                                SVProgressHUD.dismiss()
                                print("ERROR WHILE LOGGING IN \(Auth.auth().currentUser?.email)")
                            }
                        })

                        
                 
                    }
                    }
                })
                
//            }
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
        if segue.identifier == "Male" {
            
            let destinationVC = segue.destination as! SearchPartnerViewController
            destinationVC.firstNametextLable = user.name
            destinationVC.userID = user.id
            destinationVC.age = user.age
        }else if segue.identifier == "Female" {
            
            let destinationVC = segue.destination as! FemaleSearchPartnerViewController
            destinationVC.firstNametextLable = user.name
            destinationVC.userID = user.id
            destinationVC.age = user.age

        }
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

