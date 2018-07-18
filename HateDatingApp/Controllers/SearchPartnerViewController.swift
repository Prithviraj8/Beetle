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


class SearchPartnerViewController: UIViewController, CLLocationManagerDelegate {



    @IBOutlet weak var Card: UIViewX!
    @IBOutlet weak var ThumbsImageView: UIImageView!
    @IBOutlet weak var PartnerImage: UIImageViewX!
    
    let locationManager = CLLocationManager()
    var divisor: CGFloat!
    var ref: StorageReference!
    var users : [User] = [User]()
    //var profileImageUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   fetchImagesFromDatabase()
        
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
        
        fetchUsersFromFirebase()
        
       // PartnerImage.image = DataSnapshot().childSnapshot(forPath: "users")
        let scale = min(100/abs(xFromCenter), 1)
            
        //100/2 = 50/0.61 = 81.9672
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        //Affine means it preserves parellel relationships in an objext when it is rotated.
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
        
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
                return//So that the reset code does not run

            }else if card.center.x > (view.frame.width - 75) {
                //Move off to the right side.
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + 200.0, y: card.center.y + 75)
                    card.alpha = 0
                }
                return//So that the reset code does not run

            }
            resetCard()
            
        }


       
    }

    

//    if let profileImageUrl = User().profileImageURL {
//        let url = NSURL(string: profileImageUrl)
//        let request = URLRequest(url: url as! URL)
//
//        URLSession.shared.dataTask(with: request) { (data, responce, error) in
//
//            //Download hit an error so lets return out.
//            if error != nil {
//                print(error)
//                return
//            }
//            self.PartnerImage.image = UIImage(data: data!)
//
//            }.resume()
//
//    }
//
    
    @IBAction func ResetCard(_ sender: UIButton) {
        resetCard()
    }
    
    func resetCard() {

        UIView.animate(withDuration: 0.2) {
            
            self.Card.center = self.view.center
            self.ThumbsImageView.alpha = 0
            self.Card.alpha = 1
            self.Card.transform = CGAffineTransform.identity//Restore original scale, rotation of the object.
        }
    }


    func fetchUsersFromFirebase() {
        
        Firebase.Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            print("Users found")
            print(snapshot)
        }, withCancel: nil)
        
}
    //    let dbRef = database.reference().child("myFiles")
    //    dbRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
    //    // Get download URL from snapshot
    //    let downloadURL = snapshot.value() as! String
    //    // Create a storage reference from the URL
    //    let storageRef = storage.referenceFromURL(downloadURL)
    //    // Download the data, assuming a max size of 1MB (you can change this as necessary)
    //    storageRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
    //    // Create a UIImage, add it to the array
    //    let pic = UIImage(data: data)
    //    picArray.append(pic)
    //    })
    //    })
//    func fetchImagesFromDatabase() {
//        ref = Storage.storage().reference(forURL: "gs://hatedateapp-ea81a.appspot.com")
//        ref.observe(.childAdded) { (snapshot),<#arg#>  in
//            let downloadURL = snapshot.value as! String
//            let storageRef = Storage.storage().reference(forURL: downloadURL)
//            storageRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
//                self.PartnerImage.image = UIImage(data: data!)
//            })
//        }
//    }
//
    
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
// }












