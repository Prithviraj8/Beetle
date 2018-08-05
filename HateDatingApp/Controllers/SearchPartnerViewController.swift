//
//  SearchPartnerViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 07/07/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//
import Foundation
import UIKit
import AVKit
import MapKit
import Firebase
import FirebaseStorage
import Alamofire
import AlamofireImage

class SearchPartnerViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var ToggleMenuView: UIView!
    @IBOutlet weak var ResetButton: UIButton!
    
    @IBOutlet weak var ToggleButton: UIButton!
    
    @IBOutlet weak var clearFillView: UIViewX!
    @IBOutlet weak var Card: UIViewX!
    @IBOutlet weak var ThumbsImageView: UIImageView!
    @IBOutlet weak var PartnerImage: UIImageViewX!
    
    //let userid = Auth.auth().currentUser?.uid

    var profilePic = [String]()
    var userid : String = ""
   
    let locationManager = CLLocationManager()
    var divisor: CGFloat!
    var storageRef: StorageReference!
    //var profileImageUrl: String!
    var ref : DatabaseReference!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        divisor = ((view.frame.width) / 2) / (0.61)
        
        fetchUsersFromFirebase()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //========================LOCATION MANAGER FUNCTIONS=============================
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestLocation()
            
        
            }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            
            let locationValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
            
            let currentLocation = CLLocation()
            let locationLatitude = currentLocation.coordinate.latitude
            let locationLongitude = currentLocation.coordinate.longitude
            
            print("Location : \(locations) , \(locationValue.latitude) , \(locationValue.longitude)")
            print("locations == \(locationLatitude)\(locationLongitude)\(currentLocation.coordinate.latitude)\(currentLocation.coordinate.longitude)")
            
           
            
            

        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: \(error)")
    }
    
    //==========================================================================
    
    @IBAction func panGestureCard(_ sender: UIPanGestureRecognizer) {
        
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        
        
        let scale = min(100/abs(xFromCenter), 1)
            
        //100/2 = 50/0.61 = 81.9672
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        //Affine means it preserves parellel relationships in an objext when it is rotated.
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)

//        card.transform = CGAffineTransform(rotationAngle: ((view.frame.width)/2)/0.61)

        if xFromCenter > 0 {
        
            ThumbsImageView.image = #imageLiteral(resourceName: "ThumbsUp")
            ThumbsImageView.tintColor = UIColor.green
            
        }else{
            
            ThumbsImageView.image = #imageLiteral(resourceName: "thumbsDown-1")
            ThumbsImageView.tintColor = UIColor.red
            
        }
        
        ThumbsImageView.alpha = abs(xFromCenter) / view.center.x
        
        
        if sender.state == UIGestureRecognizerState.ended {
        
            if card.center.x < 75 {
                // Move off to the left side.
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x - 200.0, y: card.center.y + 75)
                    card.alpha = 0

                }
//                UIView.animate(withDuration: 1) {
//
//                    self.Card.center = self.view.center
//                    self.ThumbsImageView.alpha = 0
//                    self.Card.alpha = 1
//                    self.Card.transform = CGAffineTransform.identity//Restore original scale, rotation of the object.
//                //    self.PartnerImage.alpha = 1
//                }
            
                return//So that the reset code does not run

            }else if card.center.x > (view.frame.width - 75) {
                //Move off to the right side.
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + 200.0, y: card.center.y + 75)
                    card.alpha = 0
                }
//                UIView.animate(withDuration: 1) {
//
//                    self.Card.center = self.view.center
//                    self.ThumbsImageView.alpha = 0
//                    self.Card.alpha = 1
//                    self.Card.transform = CGAffineTransform.identity//Restore original scale, rotation of the object.
//                    //self.PartnerImage.alpha = 1
//                }
                return//So that the reset code does not run

                }
            }
            resetCard()

            


       
    }


//    @IBAction func ToggleMenuPressed(_ sender: UIButton) {
//
//        if self.clearFillView.transform == .identity {
//            UIView.animate(withDuration: 1, animations: {
//                self.clearFillView.transform = CGAffineTransform(scaleX: 10, y: 10)
//                self.ToggleMenuView.transform = CGAffineTransform(translationX: 0, y: -88)
//                self.ToggleButton.transform = CGAffineTransform(rotationAngle: 3.14)
//            }) { (true) in
////                UIView.animate(withDuration: 0.5, animations: {
////                    self.toggleShareButtons()
////                })
//            }
//        } else {
//            UIView.animate(withDuration: 1, animations: {
//                self.ToggleMenuView.transform = .identity
//                self.ToggleButton.transform = .identity
//                self.clearFillView.transform = .identity
//            }) { (true) in
//
//            }
//        }
//    }
 
//    func toggleShareButtons() {
////        let alpha = CGFloat(ResetButton.alpha == 0 ? 1 : 0)
////        ResetButton.alpha = alpha
//        //Login.alpha = alpha

//    }
    
    
    @IBAction func ResetCard(_ sender: Any) {
        resetCard()

    }
    
    func resetCard() {

        UIView.animate(withDuration: 0.2) {
            
            self.Card.center = self.view.center
            self.ThumbsImageView.alpha = 0
            self.Card.alpha = 1
            self.Card.transform = CGAffineTransform.identity//Restore original scale, rotation of the object.
            self.PartnerImage.alpha = 1
            

        }
    }

    func fetchUsersFromFirebase() {
        
        Firebase.Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            print("Users found : ")
            print(snapshot)
            
       let snapshotValue = snapshot.value as! Dictionary<String,String>
 
            let pic = snapshotValue["Profile Pic "]
            let users =  User()
            self.profilePic.append(pic!)
            users.profileImageURL = pic
       
            print("This is pic :::::: \(String(describing: pic?.description))")
            print("This is the 1st image : \(String(describing: self.profilePic.first))")
            
//            let lowerBound = self.profilePic.index(self.profilePic.startIndex, offsetBy: 0)
//            let upperBound = self.profilePic.index(self.profilePic.startIndex, offsetBy: self.profilePic.endIndex)
           // let mySubstring = self.profilePic[lowerBound..<upperBound]

          //  for indexOfProfilePic in 0..<self.profilePic.count {
               
//                let myString: String!
//                myString = self.profilePic[indexOfProfilePic]
//                print("The pic in the array we picked is : \(myString)")

            
            
            if let actualPic = self.profilePic.first {
              
                guard let url = URL(string: actualPic) else {
                    
                    return
                }
                
               // self.postImage(url: url)
                
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if error != nil {
                        print("Failed while fetching images : \(error?.localizedDescription)")
                        return
                    } else {
                        print("Successfully fetched images from database ")
                        //Posting the downloaded image from firbase database onto the imageView.
                        DispatchQueue.main.async {
                            self.PartnerImage.layer.cornerRadius = 10
                            self.PartnerImage.layer.masksToBounds = true
                            self.PartnerImage.contentMode = .scaleAspectFill


                            self.PartnerImage.image = UIImage(data: data!)



                            //self.PartnerImage.image = UIImage(named: actualPic)

                        }
                    }

                }).resume()
                
            }
              
            //}
            
        }, withCancel: nil)
    

    
   }
    
//    func postImage(url : URL) {
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            if error != nil {
//                print("Failed while fetching images : \(error?.localizedDescription)")
//                return
//            } else {
//                print("Successfully fetched images from database ")
//                //Posting the downloaded image from firbase database onto the imageView.
//                DispatchQueue.main.async {
//                    self.PartnerImage.layer.cornerRadius = 10
//                    self.PartnerImage.layer.masksToBounds = true
//                    self.PartnerImage.contentMode = .scaleAspectFill
//
//
//                    self.PartnerImage.image = UIImage(data: data!)
//
//
//
//                    //self.PartnerImage.image = UIImage(named: actualPic)
//
//                }
//            }
//
//        }).resume()
//    }

}
//extension String {
//    subscript (bounds: CountableClosedRange<Int>) -> String {
//
//        let start = index(startIndex, offsetBy: bounds.lowerBound)
//        let end = index(startIndex, offsetBy: bounds.upperBound)
//        return String(self[start...end])
//
//    }
//}
















